require "Common/define"
require "Common/protocal"
require "Common/functions"

Event = require 'events'

local sproto = require "3rd/sproto/sproto"
local print_r = require "3rd/sproto/print_r"

Network = {};
ProtoSchema = nil


local this = Network;

local transform;
local gameObject;
local islogging = false;
local msgCfgs = dofile "Config/msg_cfg"


function Network.Start() 
    logWarn("Network.Start!!");
end

--Socket消息--
function Network.OnSocket(key, data)
    -- local rpt = string.format("==========>>>>>>%s",key)
    -- if data then
    --     local bf = data:ReadBuffer()
    --     rpt = rpt .. bf
    -- end
    -- print(rpt)
    Event.Brocast(key, data);
end

--当连接建立时--
function Network.OnConnect() 
    logWarn("Game Server connected!!")
    CtrlMgr.SendMsg("OnNetwork","EndRequest")
    --Network.HelloToSrv("hello server")
end

--当发送消息时，发现链接已断开--
function Network.OnDisconnected()
    CtrlMgr.SendMsg("OnNetwork","EndRequest")
    CtrlMgr.SendMsg("OnNetwork","BeginRequest")
    networkMgr:SendConnect() 
    logWarn("Game Server connected!!")
    --Network.HelloToSrv("hello server")
end



--异常断线--
function Network.OnException() 
    islogging = false;
    CtrlMgr.SendMsg("OnNetwork","EndRequest")
    CtrlMgr.SendMsg("OnNetwork","BeginRequest") 
    NetManager:SendConnect();
   	logError("OnException------->>>>");
end

--连接中断，或者被踢掉--
function Network.OnDisconnect() 
    islogging = false; 
    logError("OnDisconnect------->>>>");
end 


function Network.OnHeartBeat(v_oByteBuffer)
    local iMsgId = v_oByteBuffer:ReadShort()
    local sRsp = v_oByteBuffer:ReadString()
    --print("#HeartBeat: #"..iMsgId.." "..sRsp)
end

function Network.OnRawText(v_oByteBuffer)
    local sRsp = v_oByteBuffer:ReadString()
    print("#RawText: "..sRsp)
end


--普通消息的处理
function Network.OnMessage(v_oByteBuffer)
    local iMsgId = v_oByteBuffer:ReadShort()
    local theMsgCfg = msgCfgs.S2C[iMsgId]
    if not theMsgCfg then
        iMsgId = iMsgId or nil
        logError(iMsgId.." can't find in msg_cfg")
        return
    end
    local pbStr = v_oByteBuffer:ReadBuffer()
    --print("pbStr = "..string.printByte(pbStr))
    local sProto = ProtoSchema:decode(theMsgCfg.ProtoName,pbStr)
    --print("Network.OnMessage iMsgId = "..iMsgId.." sProto = "..print_table(sProto))
    Event.BrocastMsg(iMsgId,sProto)
end


--卸载网络监听--
function Network.Unload()
    logWarn('Unload Network...')
end

function Network.InitMsg()
    --初始化协议
    -- local spbinData = resMgr:LoadBinaryData(MyTools.MessagePath.."Message.pb")
    -- if not spbinData then
    --     print("spbinData = nil")
    -- end
    -- print("type of spbinData is "..type(spbinData))
    local schemaC2S = dofile "message_c2s"
    local schemaS2C = dofile "message_s2c"
    local schemaDB = dofile "db_data"
    local schema = schemaC2S .. schemaS2C .. schemaDB
    ProtoSchema = sproto.parse(schema)
    assert(ProtoSchema)
    local onNetworkCtrl = CtrlMgr.GetOrCreateCtrl("OnNetwork")
    onNetworkCtrl:Prepare()
    --连接服务器
    AppConst.SocketAddress = "192.168.1.4"
    AppConst.SocketPort = 8888
    --print("onNetworkCtrl:BeginRequest()")

    CtrlMgr.SendMsg("OnNetwork","BeginRequest")
    networkMgr:SendConnect()
    --local strEncode = ProtoSchema:encode("RspRegist",{usrName = "dffes",passwd = "1111"})
    --print(string.printByte(strEncode))
end


function Network.SendMsg(v_iMsgId,v_tMsg)
    local theMsgCfg = msgCfgs.C2S[v_iMsgId]
    if not theMsgCfg then
        v_iMsgId = v_iMsgId or nil
        logError(v_iMsgId.." can't find in msg_cfg")
        return
    end
    --print("encode table : "..print_table(v_tMsg))
    --print("encode msg into "..theMsgCfg.ProtoName)

    -- if not ProtoSchema:exist_type(theMsgCfg.ProtoName) then
    --     print("don't have ProtoName "..theMsgCfg.ProtoName)
    -- end
    local sProtoStrBuf = ProtoSchema:encode(theMsgCfg.ProtoName,v_tMsg)
    --print(string.printByte(sProtoStrBuf))

    --local tbp = ProtoSchema:decode(theMsgCfg.ProtoName,sProtoStrBuf)
    --print("tbp = {\n"..print_table(tbp).."\n}")
    networkMgr:SendMessage(ProtocalC2S.Msg,v_iMsgId,sProtoStrBuf)
end

function Network.SendRawText(v_sMsg)
    networkMgr:SendMessage(ProtocalC2S.RawText,0,sProtoStrBuf)
end