--[[
output from excel Asset.资源.xlsx
--note:
配置UIPrefab的路径
配置View的控件
colums:
{Key,键} ,{Ab,AssetBoundle} ,{Layer,层} ,{AssetName,资源名} ,{Name,名字} ,{View,视图} ,{Path,路径} ,{Type,类型}
primary key:
#0 [UI]: Key
#1 [View]: Key,HelpCol,Widget
]]
local _T = LangUtil.Language
if ddt["asset_cfg"] ~= nil then
	return ddt["asset_cfg"]
end
local data = {
	OnNetwork = {
		Key = "OnNetwork",
		Ab = "OnNetwork",
		Layer = 99,
		AssetName = "OnNetwork",
		Name = "OnNetworkPanel",
		View = "on_network_panel",
		Path = "Art/UI/Prefab/Main_HomePage/OnNetwork",
		Widgets = {
			comImgSlice1 = {Type = "Image",Path = "OnNetAnim/Slice1"},
			comImgSlice2 = {Type = "Image",Path = "OnNetAnim/Slice2"},
			comImgSlice3 = {Type = "Image",Path = "OnNetAnim/Slice3"},
			comImgSlice4 = {Type = "Image",Path = "OnNetAnim/Slice4"},
			comImgSlice5 = {Type = "Image",Path = "OnNetAnim/Slice5"},
			comImgSlice6 = {Type = "Image",Path = "OnNetAnim/Slice6"},
			comImgSlice7 = {Type = "Image",Path = "OnNetAnim/Slice7"},
			comImgSlice8 = {Type = "Image",Path = "OnNetAnim/Slice8"}
		}
	},
	Login = {
		Key = "Login",
		Ab = "Login",
		Layer = 1,
		AssetName = "Login",
		Name = "LoginPanel",
		View = "login_panel",
		Path = "Art/UI/Prefab/Main_Login/Login",
		Widgets = {
			goUsrName = {Type = "GameObject",Path = "Login/UsrName"},
			goPswd = {Type = "GameObject",Path = "Login/Passwd"},
			comIptUserName = {Type = "InputField",Path = "Login/UsrName/InputField"},
			comIptPasswd = {Type = "InputField",Path = "Login/Passwd/InputField"},
			goBtnLoginEnsure = {Type = "GameObject",Path = "Login/BtnEnsure"},
			goBtnBack = {Type = "GameObject",Path = "Login/BtnBack"},
			comTxtBtnEnsure = {Type = "Text",Path = "Login/BtnEnsure/Text"},
			goBtnRegist = {Type = "GameObject",Path = "Login/BtnRegist"},
			goTxtWarning = {Type = "GameObject",Path = "Login/TxtWarning"},
			comTxtWarning = {Type = "Text",Path = "Login/TxtWarning"}
		}
	},
	Regist = {
		Key = "Regist",
		Ab = "Login",
		Layer = 1,
		AssetName = "Regist",
		Name = "RegistPanel",
		View = "regist_panel",
		Path = "Art/UI/Prefab/Main_Login/Regist",
		Widgets = {
			goUsrName = {Type = "GameObject",Path = "Regist/UsrName/InputField"},
			comIptUsrName = {Type = "InputField",Path = "Regist/UsrName/InputField"},
			goPswd = {Type = "GameObject",Path = "Regist/Pswd/InputField"},
			comIptPswd = {Type = "InputField",Path = "Regist/Pswd/InputField"},
			goPswdCfm = {Type = "GameObject",Path = "Regist/PswdCfm/InputField"},
			comIptPswdCfm = {Type = "InputField",Path = "Regist/PswdCfm/InputField"},
			goBtnRegistEnsure = {Type = "GameObject",Path = "Regist/BtnEnsure"},
			goBtnBack = {Type = "GameObject",Path = "Regist/BtnBack"},
			goTxtWarning = {Type = "GameObject",Path = "Regist/TxtWarning"},
			comTxtWarning = {Type = "Text",Path = "Regist/TxtWarning"}
		}
	},
	HomePage = {
		Key = "HomePage",
		Ab = "HomePage",
		Layer = 1,
		AssetName = "MainPage",
		Name = "HomePagePanel",
		View = "homepage_panel",
		Path = "Art/UI/Prefab/Main_HomePage/MainPage",
		Widgets = {
			goBtnSetting = {Type = "GameObject",Path = "BtnSetting"},
			goSettingPanel = {Type = "GameObject",Path = "SettingPanel"},
			goBtnGoBackLogin = {Type = "GameObject",Path = "SettingPanel/BtnGoBackLogin"},
			goBtnSettingPanelClose = {Type = "GameObject",Path = "SettingPanel/BtnClose"}
		}
	},
	SetNickName = {
		Key = "SetNickName",
		Ab = "HomePage",
		Layer = 1,
		AssetName = "SetNickName",
		Name = "SetNickNamePanel",
		View = "setnickname_panel",
		Path = "Art/UI/Prefab/Main_HomePage/SetNickName",
		Widgets = {
			goTxtWarning = {Type = "GameObject",Path = "Warning"},
			comTxtWarning = {Type = "Text",Path = "Warning/Text"},
			comIptNickName = {Type = "InputField",Path = "IptNickName"},
			goBtnEnsure = {Type = "GameObject",Path = "BtnEnsure"}
		}
	}
}
ddt["asset_cfg"] = data
return data