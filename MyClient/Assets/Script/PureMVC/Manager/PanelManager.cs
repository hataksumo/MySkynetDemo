using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;
using System.Diagnostics;
using System;

namespace LuaFramework {
    public class PanelManager : Manager {
        private Transform parent;
        private Transform back;
        private Transform main;
        private Transform front;
        private Transform tip;

        Transform Back {
            get {
                if (back == null)
                {
                    GameObject go = GameObject.FindWithTag("Back");
                    if (go != null) back = go.transform;
                }
                return back;
            }
        }

        Transform Main {
            get
            {
                if (main == null)
                {
                    GameObject go = GameObject.FindWithTag("Main");
                    if (go != null) main = go.transform;
                }
                return main;
            }
        }

        Transform Front {
            get 
            {
                if (front == null)
                {
                    GameObject go = GameObject.FindWithTag("Front");
                    if (go != null) front = go.transform;
                }
                return front;
            }
        }

        Transform Tip {
            get {
                if (tip == null)
                {
                    GameObject go = GameObject.FindWithTag("Tip");
                    if (go != null) tip = go.transform;
                }
                return tip;
            }
        }



        private GameObject _BuildNewPanel(UnityEngine.Object[] objs,string v_logicName, string v_abname, string v_assetName, string v_panelName)
        {
            if (objs.Length == 0)
            {
                ZFDebug.Error(string.Format("can't find the uiRes abName = {0}, assetName = {1}", v_abname, v_assetName));
                return null;
            }
            GameObject prefab = objs[0] as GameObject;
            if (prefab == null) return null;

            GameObject go = Instantiate(prefab) as GameObject;
            go.name = v_panelName;
            go.layer = LayerMask.NameToLayer("UI");
            //go.transform.SetParent(Parent);
            //go.transform.localScale = Vector3.one;
            //go.transform.localPosition = Vector3.zero;
            RectTransform rt = go.GetComponent<RectTransform>();
            rt.localPosition = Vector3.zero;
            rt.localScale = Vector3.one;
            rt.localRotation = Quaternion.Euler(0, 0, 0);
            rt.anchorMin = new Vector2(0.5f, 0.5f);
            rt.anchorMax = new Vector2(0.5f, 0.5f);
            rt.pivot = new Vector2(0.5f, 0.5f);
            rt.sizeDelta = new Vector2(750,1334);
            rt.ForceUpdateRectTransforms();
            var comLuabehaviour = go.AddComponent<LuaBehaviour>();
            comLuabehaviour.sLogicName = v_logicName;
            comLuabehaviour.sBundleName = v_abname;
            return go;
        }

        private Transform getParent(int v_layer)
        {
            switch (v_layer)
            {
                case 0:
                    return Back;
                case 1:
                    return Main;
                case 2:
                    return Front;
                case 99:
                    return Tip;
                default:
                    return Front;
            }
            
        }

        public void CreateThePanel(int v_layer,string v_logicName,string v_abname, string v_assetName, string v_panelName, LuaFunction v_func = null)
        {
            string assetName = v_assetName;
            string abName = v_abname.ToLower() + AppConst.ExtName;
            Transform Parent = getParent(v_layer);
            if (Parent.Find(name) != null) return;
            ResManager.LoadPrefab(abName, assetName, delegate (UnityEngine.Object[] objs) {
                GameObject go = _BuildNewPanel(objs, v_logicName, abName, assetName, v_panelName);
                go.transform.SetParent(Parent);
                if (go == null)
                {
                    ZFDebug.Error("create panel failed, logic name is " + v_logicName);
                    return;
                }
                go.SetActive(false);
                if (v_func != null) v_func.Call(go);
            });
        }

        /// <summary>
        /// 关闭面板
        /// </summary>
        /// <param name="name"></param>
        public void ClosePanel(int v_layer, string name) {
            var panelName = name;
            Transform Parent = getParent(v_layer);
            var panelObj = Parent.Find(panelName);
            if (panelObj == null) {
                ZFDebug.Error("ClosePanel can't find the node " + name);
                return;
            };
            Destroy(panelObj.gameObject);
        }

        public void Hide(int v_layer, string name) {
            var panelName = name;
            Transform Parent = getParent(v_layer);
            var panelObj = Parent.Find(panelName);
            if (panelObj == null)
            {
                ZFDebug.Error("Hide can't find the node " + name);
                return;
            }
            panelObj.gameObject.SetActive(false);
        }

        public void Show(int v_layer, string name) {
            var panelName = name;
            Transform Parent = getParent(v_layer);
            var panelObj = Parent.Find(panelName);
            if (panelObj == null)
            {
                ZFDebug.Info(Parent.name+ " " + Parent.childCount.ToString());
                ZFDebug.Error("can't find the panel named " + panelName);
                return;
            }
            panelObj.gameObject.SetActive(true);
        }

        public void ShowUnique(int v_layer, string name) {
            Transform Parent = getParent(v_layer);
            int cnt = Parent.transform.childCount;
            for (int i = 0; i < cnt; i++)
            {
                GameObject childGo = Parent.GetChild(i).gameObject;
                if (childGo.name == name || childGo.name == "Back")
                {
                    childGo.SetActive(true);
                }
                else
                {
                    childGo.SetActive(false);
                }
            }
        }

        public void ClearExcept(int v_layer, string name)
        {
            Transform Parent = getParent(v_layer);
            int cnt = Parent.transform.childCount;
            for (int i = 0; i < cnt; i++)
            {
                GameObject childGo = Parent.GetChild(i).gameObject;
                if (childGo.name == name)
                {
                    childGo.SetActive(true);
                }
                else
                {
                    Destroy(childGo);
                }
            }
        }

        System.Diagnostics.Stopwatch stopwatch = new Stopwatch();
        public void Update()
        {
            //stopwatch.Start(); // 开始监视代码运行时间
            Util.CallMethod("Game","OnUpdate",Time.deltaTime);
            //stopwatch.Stop();
            //TimeSpan timespan = stopwatch.Elapsed; // 获取当前实例测量得出的总时间
            //double milliseconds = timespan.TotalMilliseconds; // 总毫秒数
            //stopwatch.Reset();
            //stopwatch.Start();
            //stopwatch.Stop();
            //TimeSpan timespan2 = stopwatch.Elapsed; // 获取当前实例测量得出的总时间
            //double milliseconds2 = timespan2.TotalMilliseconds; // 总毫秒数
            //ZFDebug.Info("调用Update使用" + (milliseconds - milliseconds2) + "毫秒");
        }

    }
}