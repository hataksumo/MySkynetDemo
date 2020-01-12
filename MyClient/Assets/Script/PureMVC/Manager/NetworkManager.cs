using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;
using System.IO;

namespace LuaFramework {
    public class NetworkManager : Manager {
        private SocketClient socket;
        static readonly object m_lockObject = new object();
        static Queue<KeyValuePair<ushort, ByteBuffer>> mEvents = new Queue<KeyValuePair<ushort, ByteBuffer>>();

        SocketClient SocketClient {
            get { 
                if (socket == null)
                    socket = new SocketClient();
                return socket;                    
            }
        }

        void Awake() {
            Init();
        }

        void Init() {
            SocketClient.OnRegister();
        }

        public void OnInit() {
            CallMethod("Start");
        }

        public void Unload() {
            CallMethod("Unload");
        }

        /// <summary>
        /// ִ��Lua����
        /// </summary>
        public object[] CallMethod(string func, params object[] args) {
            return Util.CallMethod("Network", func, args);
        }

        ///------------------------------------------------------------------------------------
        public static void AddEvent(ushort _event, ByteBuffer data) {
            lock (m_lockObject) {
                mEvents.Enqueue(new KeyValuePair<ushort, ByteBuffer>(_event, data));
            }
        }

        /// <summary>
        /// ����Command�����ﲻ����ķ���˭��
        /// </summary>
        void Update() {
            if (mEvents.Count > 0) {
                while (mEvents.Count > 0) {
                    KeyValuePair<ushort, ByteBuffer> _event = mEvents.Dequeue();
                    facade.SendMessageCommand(NotiConst.DISPATCH_MESSAGE, _event);
                }
            }
        }

        /// <summary>
        /// ������������
        /// </summary>
        public void SendConnect() {
            SocketClient.SendConnect();
        }

        /// <summary>
        /// ����SOCKET��Ϣ
        /// </summary>
        public void SendMessage(ushort v_iMsgType, ushort v_iMsgId,LuaByteBuffer v_oLuaByteBuffer) {
            //byte[] buffer = new byte[v_oLuaByteBuffer.Length + 6];
            ByteBuffer bf = new ByteBuffer();
            bf.WriteShort(v_iMsgType);
            bf.WriteShort(v_iMsgId);
            bf.WriteBuffer(v_oLuaByteBuffer); 
            SocketClient.SendMessage(bf);
        }

        public void SendMessage(ushort v_iMsgType, ushort v_iMsgId, string v_oLuaByteBuffer)
        {
            //byte[] buffer = new byte[v_oLuaByteBuffer.Length + 6];
            ByteBuffer bf = new ByteBuffer();
            bf.WriteShort(v_iMsgType);
            bf.WriteShort(v_iMsgId);
            bf.WriteString(v_oLuaByteBuffer);
            SocketClient.SendMessage(bf);
        }

        /// <summary>
        /// ��������
        /// </summary>
        void OnDestroy() {
            SocketClient.OnRemove();
            Debug.Log("~NetworkManager was destroy");
        }
    }
}