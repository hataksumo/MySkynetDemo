
namespace LuaFramework {
    public class Protocal {
        ///BUILD TABLE
        public const ushort Connect = 101;     //连接服务器
        public const ushort Exception = 102;     //异常掉线
        public const ushort Disconnect = 103;     //正常断线
        public const ushort Msg = 104;          //正常的消息
        public const ushort HeartBeat = 105;    //心跳
        public const ushort RawText = 100;      //纯文本
        public const ushort SrvErr = 99;        //服务器错误
    }
}