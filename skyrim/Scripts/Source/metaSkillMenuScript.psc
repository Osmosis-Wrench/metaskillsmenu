Scriptname metaSkillMenuScript extends Quest  
{Controller script for MetaSkillMenu}
; Sorry for anybody reading this, this is not a good mod to learn from. I'm doing some weird shit here.

event OnInit()
    startup()
endEvent

function startup()
    load_data()
    register_events()
endfunction

function register_events()
    registerformodevent("MetaSkillMenu_Open", "OpenMenu")
    registerformodevent("MetaSkillMenu_Close", "CloseMenu")
    registerformodevent("MetaSkillMenu_Selection", "SelectedMenu")
endfunction

function load_data()
    string[] a = JContainers.contentsOfDirectoryAtPath("data/NetScriptFramework/Plugins/", ".txt")
    int x = JArray.objectWithStrings(a)

    int y = JValue.evalLuaObj(x, "return msm.returnSkillTreeObject(jobject)")

    string filekey = jmap.nextkey(y)

    int p = Jmap.Object()
    while filekey
        int fileobj = jmap.getobj(y, filekey)
        if game.IsPluginInstalled(JMap.GetStr(fileobj, "ShowMenuFile"))
            int retobj = jvalue.deepcopy(fileobj)

            string modNameThing = jmap.getstr(fileobj, "Name") + " " +StringUtil.Split(filekey, ".")[1]

            string icon_loc = jmap.getstr(fileobj, "icon_loc")
            if JContainers.fileExistsAtPath(icon_loc)
                jmap.setint(retobj, "icon_exists", true as int)
            endif
            jmap.setobj(p, modNameThing, retobj)
        else
            writelog("FAILED TO FIND MOD, MISSING ESP: "+JMap.GetStr(fileobj, "ShowMenuFile"))
        endif
        filekey = jmap.nextkey(y, filekey)
    endwhile
    jvalue.writetofile(p, "data/interface/MetaSkillsMenu/MSMData.json")
endfunction

event OpenMenu(string eventName, string strArg, float numArg, Form sender)
    UI.OpenCustomMenu("MetaSkillsMenu/CustomMetaMenu")
endEvent

event CloseMenu(string eventName, string strArg, float numArg, Form sender)
    UI.Invoke("TweenMenu", "_root.TweenMenu_mc.ShowMenu")
endEvent

event SelectedMenu(string eventName, string strArg, float numArg, Form sender)
    int MSMData = JValue.readFromFile("data/interface/MetaSkillsMenu/MSMData.json")
    int modObject = JMap.getObj(MSMData, strArg)
    int formid = JMap.getInt(modObject, "ShowMenuId")
    string modname = JMap.getStr(modObject, "ShowMenuFile")
    Form modForm = JMap.getForm(modObject, "ShowMenuForm")

    (modForm as GlobalVariable).SetValue(1.0)
    UI.CloseCustomMenu()
endEvent

function WriteLog(string printMessage, bool error = false)
    string a = "MSM: "
    if error
        Debug.Notification(a + printMessage)
    endif
    ConsoleUtil.PrintMessage(a + printMessage)
    Debug.Trace(a + printMessage)
endfunction