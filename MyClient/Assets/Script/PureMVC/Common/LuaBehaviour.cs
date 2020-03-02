using UnityEngine;
using LuaInterface;
using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine.UI;
using UnityEngine.EventSystems;

namespace LuaFramework {
    public class LuaBehaviour : View {
        //private string data = null;
        public string sLogicName = null;
        public string sBundleName = null;
        private Dictionary<string, LuaFunction> _buttonsFunMemo = new Dictionary<string, LuaFunction>();
        private Dictionary<string, LuaFunction> _eventTrigerFunMemo = new Dictionary<string, LuaFunction>();

        protected void Awake()
        {
            if(!string.IsNullOrWhiteSpace(sLogicName))
                Util.CallMethod("ViewMgr", "Awake", sLogicName, gameObject);
        }

        protected void Start()
        {
            Util.CallMethod("ViewMgr", "Start", sLogicName, gameObject);
        }

        protected void OnClick()
        {
            Util.CallMethod("ViewMgr", "OnClick", sLogicName, gameObject);
        }

        protected void OnClickEvent(GameObject go)
        {
            Util.CallMethod("ViewMgr", "OnClickEvent", sLogicName, go);
        }

        /// <summary>
        /// 添加单击事件
        /// </summary>
        public void AddClick(GameObject go, LuaFunction luafunc) {
            if (go == null || luafunc == null)
            {
                Debug.LogError("绑定click的gameobject对象为空");
                return;
            }
                
            _buttonsFunMemo.Add(go.name, luafunc);
            go.GetComponent<Button>().onClick.AddListener(
                delegate() {
                    luafunc.Call(go);
                }
            );
        }

        public void AddEvent(GameObject go,EventTriggerType v_eType ,LuaFunction luafunc)
        {
            EventTrigger et = go.GetComponent<EventTrigger>();
            if (et == null)
            {
                et = go.AddComponent<EventTrigger>();
            }
            EventTrigger.Entry entry = new EventTrigger.Entry();
            entry.eventID = v_eType;
            _eventTrigerFunMemo.Add(go.name + "_evt" + v_eType, luafunc);
            UnityEngine.Events.UnityAction<UnityEngine.EventSystems.BaseEventData> ua = delegate (BaseEventData e) {
                luafunc.Call(e);
            };
            entry.callback.AddListener(ua);
            et.triggers.Add(entry);
        }



        /// <summary>
        /// 删除单击事件
        /// </summary>
        /// <param name="go"></param>
        public void RemoveClick(GameObject go) {
            if (go == null) return;
            LuaFunction luafunc = null;
            if (_buttonsFunMemo.TryGetValue(go.name, out luafunc)) {
                luafunc.Dispose();
                luafunc = null;
                _buttonsFunMemo.Remove(go.name);
            }
        }

        /// <summary>
        /// 清除单击事件
        /// </summary>
        public void ClearClick() {
            foreach (var de in _buttonsFunMemo) {
                if (de.Value != null) {
                    de.Value.Dispose();
                }
            }
            _buttonsFunMemo.Clear();
            foreach (var de in _eventTrigerFunMemo)
            {
                if (de.Value != null) {
                    de.Value.Dispose();
                }
            }
            _eventTrigerFunMemo.Clear();
        }

        //-----------------------------------------------------------------
        protected void OnDestroy() {
            ClearClick();
#if ASYNC_MODE
            ResManager.UnloadAssetBundle(sBundleName);
#endif
            Util.ClearMemory();
            Debug.Log("~" + sBundleName + " unload!");
        }
    }
}