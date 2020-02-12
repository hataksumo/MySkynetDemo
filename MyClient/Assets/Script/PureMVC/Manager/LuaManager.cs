using UnityEngine;
using System.Collections;
using LuaInterface;

namespace LuaFramework {
    public class LuaManager : Manager {
        private LuaState _lua;
        private LuaLoader _loader;
        private LuaLooper _loop = null;

        // Use this for initialization
        void Awake() {
            _loader = new LuaLoader();
            _lua = new LuaState();
            this.OpenLibs();
            _lua.LuaSetTop(0);

            LuaBinder.Bind(_lua);
            DelegateFactory.Init();
            LuaCoroutine.Register(_lua, this);
        }

        public void InitStart() {
            InitLuaPath();
            InitLuaBundle();
            this._lua.Start();    //启动LUAVM
            this.StartMain();
            this.StartLooper();
        }

        void StartLooper() {
            _loop = gameObject.AddComponent<LuaLooper>();
            _loop.luaState = _lua;
        }

        //cjson 比较特殊，只new了一个table，没有注册库，这里注册一下
        protected void OpenCJson() {
            _lua.LuaGetField(LuaIndexes.LUA_REGISTRYINDEX, "_LOADED");
            _lua.OpenLibs(LuaDLL.luaopen_cjson);
            _lua.LuaSetField(-2, "cjson");

            _lua.OpenLibs(LuaDLL.luaopen_cjson_safe);
            _lua.LuaSetField(-2, "cjson.safe");
        }

        void StartMain() {
            _lua.DoFile("Main.lua");

            LuaFunction main = _lua.GetFunction("Main");
            main.Call();
            main.Dispose();
            main = null;    
        }
        
        /// <summary>
        /// 初始化加载第三方库
        /// </summary>
        void OpenLibs() {
            _lua.OpenLibs(LuaDLL.luaopen_pb);      
            _lua.OpenLibs(LuaDLL.luaopen_sproto_core);
            //_lua.OpenLibs(LuaDLL.luaopen_protobuf_c);
            _lua.OpenLibs(LuaDLL.luaopen_lpeg);
            _lua.OpenLibs(LuaDLL.luaopen_bit);
            _lua.OpenLibs(LuaDLL.luaopen_socket_core);

            this.OpenCJson();
        }

        /// <summary>
        /// 初始化Lua代码加载路径
        /// </summary>
        void InitLuaPath() {
            if (AppConst.DebugMode) {
                string rootPath = AppConst.FrameworkRoot;
                _lua.AddSearchPath(AppConst.LogicLuaPath);
                _lua.AddSearchPath(rootPath + "/ToLua/Lua");
            } else {
                _lua.AddSearchPath(Util.DataPath + "lua");
            }
        }

        /// <summary>
        /// 初始化LuaBundle
        /// </summary>
        void InitLuaBundle() {
            if (_loader.beZip) {
                _loader.AddBundle("lua/lua.unity3d");
                _loader.AddBundle("lua/lua_math.unity3d");
                _loader.AddBundle("lua/lua_system.unity3d");
                _loader.AddBundle("lua/lua_system_reflection.unity3d");
                _loader.AddBundle("lua/lua_unityengine.unity3d");
                _loader.AddBundle("lua/lua_common.unity3d");
                _loader.AddBundle("lua/lua_logic.unity3d");
                _loader.AddBundle("lua/lua_view.unity3d");
                _loader.AddBundle("lua/lua_controller.unity3d");
                _loader.AddBundle("lua/lua_misc.unity3d");

                _loader.AddBundle("lua/lua_protobuf.unity3d");
                _loader.AddBundle("lua/lua_3rd_cjson.unity3d");
                _loader.AddBundle("lua/lua_3rd_luabitop.unity3d");
                //_loader.AddBundle("lua/lua_3rd_pbc.unity3d");
                //_loader.AddBundle("lua/lua_3rd_pblua.unity3d");
                _loader.AddBundle("lua/lua_3rd_sproto.unity3d");
            }
        }

        public void DoFile(string filename) {
            _lua.DoFile(filename);
        }

        // Update is called once per frame
        public object[] CallFunction(string funcName, params object[] args) {
            LuaFunction func = _lua.GetFunction(funcName);
            if (func != null) {
                return func.LazyCall(args);
            }
            return null;
        }

        public LuaFunction GetFunction(string funcName, params object[] args)
        {
            LuaFunction func = _lua.GetFunction(funcName);
            return func;
        }

        public void LuaGC() {
            _lua.LuaGC(LuaGCOptions.LUA_GCCOLLECT);
        }

        public void Close() {
            _loop.Destroy();
            _loop = null;

            _lua.Dispose();
            _lua = null;
            _loader = null;
        }
    }
}