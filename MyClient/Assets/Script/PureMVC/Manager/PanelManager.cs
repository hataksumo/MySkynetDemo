using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;

namespace LuaFramework {
    public class PanelManager : Manager {
        private Transform parent;

        Transform Parent {
            get {
                if (parent == null) {
                    GameObject go = GameObject.FindWithTag("UiRoot");
                    if (go != null) parent = go.transform;
                }
                return parent;
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
            go.transform.SetParent(Parent);
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

        public void CreateThePanel(string v_logicName,string v_abname, string v_assetName, string v_panelName, LuaFunction v_func = null)
        {
            string assetName = v_assetName;
            string abName = v_abname.ToLower() + AppConst.ExtName;
            if (Parent.Find(name) != null) return;
            ResManager.LoadPrefab(abName, assetName, delegate (UnityEngine.Object[] objs) {
                GameObject go = _BuildNewPanel(objs, v_logicName, abName, assetName, v_panelName);
                if (go == null)
                {
                    ZFDebug.Error("create panel failed, logic name is " + v_logicName);
                    return;
                }
                go.SetActive(false);
                if (v_func != null) v_func.Call(go);
            });
        }

        //public void SwitchToNewPanel(string v_abname, string v_assetName, string v_panelName, LuaFunction v_func = null)
        //{
        //    string assetName = v_assetName;
        //    string abName = v_abname.ToLower() + AppConst.ExtName;
        //    if (Parent.Find(name) != null) return;
        //    ResManager.LoadPrefab(abName, assetName, delegate (UnityEngine.Object[] objs)
        //    {
        //        GameObject go = _BindNewPanel(objs, abName, assetName, v_panelName);
        //        if (go == null) return;
        //        ClearExcept(v_panelName);
        //        if (v_func != null) v_func.Call(go);

        //    });
        //}

        /// <summary>
        /// πÿ±’√Ê∞Â
        /// </summary>
        /// <param name="name"></param>
        public void ClosePanel(string name) {
            var panelName = name;
            var panelObj = Parent.Find(panelName);
            if (panelObj == null) return;
            Destroy(panelObj.gameObject);
        }

        public void Hide(string name) {
            var panelName = name;
            var panelObj = Parent.Find(panelName);
            if (panelObj == null) return;
            panelObj.gameObject.SetActive(false);
        }

        public void Show(string name) {
            var panelName = name;
            var panelObj = Parent.Find(panelName);
            if (panelObj == null)
            {
                ZFDebug.Error("can't find the panel named " + panelName);
            }
            panelObj.gameObject.SetActive(true);
        }

        public void ShowUnique(string name) {
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

        public void ClearExcept(string name)
        {
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

        private void test()
        {
        }

    }
}