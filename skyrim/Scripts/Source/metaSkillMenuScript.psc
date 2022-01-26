Scriptname metaSkillMenuScript extends Quest  
{Controller script for MetaSkillMenu}
; Sorry for anybody reading this, this is not a good mod to learn from. I'm doing some weird shit here.

bool b_CustomSkillsExists = false
bool b_SkillTreesInstalled = false

event OnInit()
    startup()
endEvent

function startup()
    if doSafetyCheck()
        load_data()
        register_events()
    endif
endfunction

bool function doSafetyCheck()
    If !jcontainers.isInstalled()
        Writelog("JContainers is not detected!\nMake sure you are using JContainers SE v4.1.13 which is the last version to support Skyrim 1.5.39\n\n(jcontainers.isInstalled() did not return true)", 2)
        b_CustomSkillsExists = false
        return false
    else
        if jcontainers.fileExistsAtPath("data/NetScriptFramework/Plugins/CustomSkills.dll")
            b_CustomSkillsExists = true
            return true
        Else
            b_CustomSkillsExists = false
            Writelog("Custom Skill Framework by Meh321 was not detected, make sure the mod is installed correctly.\n(Failed to find CustomSkills.dll)", 2)
            return false
        endif
    endif
endFunction

function register_events()
    registerformodevent("MetaSkillMenu_Open", "OpenMenu")
    registerformodevent("MetaSkillMenu_Close", "CloseMenu")
    registerformodevent("MetaSkillMenu_Selection", "SelectedMenu")
endfunction

function load_data()
    string[] a = JContainers.contentsOfDirectoryAtPath("data/NetScriptFramework/Plugins/", ".txt")
    int x = JArray.objectWithStrings(a)

    int y = JValue.evalLuaObj(x, "return msm.returnSkillTreeObject(jobject)")
    jvalue.release(x)

    string filekey = jmap.nextkey(y)

    int hideData
    if jcontainers.fileExistsAtPath("data/interface/MetaSkillsMenu/MSMHidden.json")
        hideData = JValue.readFromFile("data/interface/MetaSkillsMenu/MSMHidden.json")
    Else
        hideData = Jmap.Object()
    endif
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
            int valuetype = JValue.solvedValueType(hideData, "."+modNameThing+".hidden")
            if valuetype != 2
                JValue.SolveIntSetter(hideData, "."+modNameThing+".hidden", false as int, true)
            endif
            jmap.setInt(retObj, "hidden", JValue.SolveInt(hideData, "."+modNameThing+".hidden"))
        else
            writelog("FAILED TO FIND MOD, MISSING ESP: "+JMap.GetStr(fileobj, "ShowMenuFile"))
        endif
        filekey = jmap.nextkey(y, filekey)
    endwhile
    jvalue.release(y)
    if (jmap.count(p) > 0)
        b_SkillTreesInstalled = true
    Else
        b_SkillTreesInstalled = false
    endif

    jvalue.writetofile(hideData, "data/interface/MetaSkillsMenu/MSMHidden.json")
    jvalue.writetofile(p, "data/interface/MetaSkillsMenu/MSMData.json")
    jvalue.release(hideData)
    jvalue.release(p)
endfunction

event OpenMenu(string eventName, string strArg, float numArg, Form sender)
    doOpenMenu()
endEvent

function doOpenMenu()
    if b_CustomSkillsExists && b_SkillTreesInstalled
        UI.OpenCustomMenu("MetaSkillsMenu/CustomMetaMenu")
    else
        UI.Invoke("TweenMenu", "_root.TweenMenu_mc.ShowMenu")
        Writelog("No skill trees found, closing menu.", 1)
    endif
endFunction

event CloseMenu(string eventName, string strArg, float numArg, Form sender)
    doCloseMenu()
endEvent

function doCloseMenu()
    UI.Invoke("TweenMenu", "_root.TweenMenu_mc.ShowMenu")
endFunction

event SelectedMenu(string eventName, string strArg, float numArg, Form sender)
    int MSMData = JValue.readFromFile("data/interface/MetaSkillsMenu/MSMData.json")
    int modObject = JMap.getObj(MSMData, strArg)
    int formid = JMap.getInt(modObject, "ShowMenuId")
    string modname = JMap.getStr(modObject, "ShowMenuFile")
    Form modForm = JMap.getForm(modObject, "ShowMenuForm")

    (modForm as GlobalVariable).SetValue(1.0)
    UI.CloseCustomMenu()
endEvent

function WriteLog(string printMessage, int error = 0)
    string a = "Custom Skill Menu: "
    if error >= 1
        Debug.Notification(a + printMessage)
    endif
    if error >= 2
        Debug.MessageBox(a +"\n"+ printMessage)
    endif
    ConsoleUtil.PrintMessage(a + printMessage)
    Debug.Trace(a + printMessage)
endfunction