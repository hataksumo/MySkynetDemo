using System.Collections;
using System.Collections.Generic;
using System;
using System.IO;
using UnityEditor;
using UnityEngine;
using LuaInterface;
using LuaFramework;

public static class CustomEditor
{
    [MenuItem("Custom/screen shot")]
    public static void ScreenShot()
    {
        Camera uiCamera = GameObject.Find("UICamera").GetComponent<Camera>();
        Rect shootArea = new Rect();
        shootArea.position = new Vector2(0, 0);
        shootArea.width = uiCamera.orthographicSize * 2 * uiCamera.aspect;
        shootArea.height = uiCamera.orthographicSize * 2;
        CaptrueCamera(uiCamera, shootArea);

    }

    [MenuItem("Custom/编译sproto")]
    static void CompileSproto()
    {
        try
        {
            LuaState l = getAndIniLuaState();
            l.DoFile("EditorMain");
            LuaFunction fun = l.GetFunction("CompileSproto");
            fun.Call();
            l.Dispose();
        }
        catch (Exception ex)
        {
            ZFDebug.Error(ex.ToString());
        }
    }


    static EditorMain _client;
    //[MenuItem("Custom/执行Main")]
    static void DoMain()
    {
        if (_client == null)
        {
            var es = GameObject.Find("EventSystem");
            _client = es.GetComponent<EditorMain>();
            if (_client == null)
                _client = es.AddComponent<EditorMain>();
            _client.init();
        }
        else
            _client.reload();
        try
        {
            _client.test();
        }
        catch (Exception ex)
        {
            ZFDebug.Error(ex.ToString());
        }

    }

    //[MenuItem("Custom/清空lua")]
    static void ClearLuaState()
    {
        if (_client != null)
        {
            _client.Destroy();
            _client = null;
        }
    }


    //[MenuItem("Custom/导出Excel")]
    static void OutputExcel()
    {
        try
        {
            _client.output_excel();
        }
        catch (Exception ex)
        {
            ZFDebug.Error(ex.ToString());
        }
    }

    private static LuaState getAndIniLuaState()
    {
        LuaState l = new LuaState();
        l.Start();
        l.OpenLibs(LuaDLL.luaopen_pb);
        l.OpenLibs(LuaDLL.luaopen_sproto_core);
        //l.OpenLibs(LuaDLL.luaopen_protobuf_c);
        l.OpenLibs(LuaDLL.luaopen_lpeg);
        l.OpenLibs(LuaDLL.luaopen_bit);
        l.OpenLibs(LuaDLL.luaopen_socket_core);
        LuaBinder.Bind(l);
        string rootPath = AppConst.FrameworkRoot;
        l.AddSearchPath(AppConst.LogicLuaPath);
        l.AddSearchPath(rootPath + "/ToLua/Lua");

        return l;
    }



    public static Texture2D CaptrueCamera(Camera camera, Rect rect)
    {
        // 创建一个RenderTexture对象
        RenderTexture rt = new RenderTexture((int)rect.width, (int)rect.height, 0);
        // 临时设置相关相机的targetTexture为rt, 并手动渲染相关相机
        RenderTexture orgrt = camera.targetTexture;
        camera.targetTexture = rt;
        camera.Render();
        camera.targetTexture = orgrt;
        // 激活这个rt, 并从中中读取像素。  
        RenderTexture.active = rt;
        Texture2D screenShot = new Texture2D((int)rect.width, (int)rect.height, TextureFormat.RGB24, false);
        screenShot.ReadPixels(rect, 0, 0);// 注：这个时候，它是从RenderTexture.active中读取像素  
        screenShot.Apply();

        // 重置相关参数，以使用camera继续在屏幕上显示  
        camera.targetTexture = null;
        //ps: camera2.targetTexture = null;  
        RenderTexture.active = null; // JC: added to avoid errors  
        GameObject.DestroyImmediate(rt);
        string formatType = ".png";
        string formatTime = DateTime.Now.ToString();
        formatTime = formatTime.Replace('/', '-').Replace(' ', '-').Replace(':', '-').ToString();
        
        // 最后将这些纹理数据，成一个png图片文件  
        byte[] bytes = screenShot.EncodeToPNG();
        string filename = null;
        string path =  Path.GetFullPath(Application.dataPath + "/../ScreenShoot/");
        filename = path + formatTime + formatType; 
        if (!Directory.Exists(path))
        {
            Debug.Log("create forder " + path);
            Directory.CreateDirectory(path);
        }
        System.IO.File.WriteAllBytes(filename, bytes);
        Debug.Log(string.Format("截屏了一张照片: {0}", filename));
        //ScreenCapture.CaptureScreenshot(filename, 0);

        return screenShot;
    } 
}
