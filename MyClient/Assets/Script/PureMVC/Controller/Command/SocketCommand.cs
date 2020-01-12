using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using LuaFramework;

public class SocketCommand : ControllerCommand {

    public override void Execute(IMessage message) {
        object data = message.Body;
        if (data == null) return;
        KeyValuePair<ushort, ByteBuffer> buffer = (KeyValuePair<ushort, ByteBuffer>)data;
        //ZFDebug.Info("On SocketCommand type = " + buffer.Key);
        switch (buffer.Key) {
            case Protocal.Connect:
                Util.CallMethod("Network", "OnConnect", buffer.Value);
                break;
            case Protocal.Disconnect:
                Util.CallMethod("Network", "OnDisconnect", buffer.Value);
                break;
            case Protocal.Exception:
                Util.CallMethod("Network", "OnException", buffer.Value);
                break;
            case Protocal.Msg:
                Util.CallMethod("Network", "OnMessage", buffer.Value);
                break;
            case Protocal.HeartBeat:
                Util.CallMethod("Network", "OnHeartBeat", buffer.Value);
                break;
            case Protocal.RawText:
                Util.CallMethod("Network", "OnRawText", buffer.Value);
                break;

            default: Util.CallMethod("Network", "OnSocket", buffer.Key, buffer.Value); break;
        }
	}
}
