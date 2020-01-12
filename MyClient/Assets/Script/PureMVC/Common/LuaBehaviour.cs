using UnityEngine;
using LuaInterface;
using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine.UI;

namespace LuaFramework {
    public class LuaBehaviour : View {
        private string data = null;
        public string sLogicName = null;
        public string sBundleName = null;
        private Dictionary<string, LuaFunction> buttons = new Dictionary<string, LuaFunction>();

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
                
            buttons.Add(go.name, luafunc);
            go.GetComponent<Button>().onClick.AddListener(
                delegate() {
                    luafunc.Call(go);
                }
            );
        }

        /// <summary>
        /// 删除单击事件
        /// </summary>
        /// <param name="go"></param>
        public void RemoveClick(GameObject go) {
            if (go == null) return;
            LuaFunction luafunc = null;
            if (buttons.TryGetValue(go.name, out luafunc)) {
                luafunc.Dispose();
                luafunc = null;
                buttons.Remove(go.name);
            }
        }

        /// <summary>
        /// 清除单击事件
        /// </summary>
        public void ClearClick() {
            foreach (var de in buttons) {
                if (de.Value != null) {
                    de.Value.Dispose();
                }
            }
            buttons.Clear();
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