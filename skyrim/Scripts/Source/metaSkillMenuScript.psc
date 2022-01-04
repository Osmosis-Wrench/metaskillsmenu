Scriptname metaSkillMenuScript extends Quest  
{Controller script for MetaSkillMenu}

event OnInit()
    load_data()
    register_events()
endEvent

function register_events()
    registerformodevent("MetaSkillMenu_Open", "OpenMenu")
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
        int retobj = jvalue.deepcopy(fileobj)

        if (jmap.getint(fileobj, "icon_exists") as bool)
            ;return ; if file exists, don't bother reprocessing.
        endif

        string modNameThing = jmap.getstr(fileobj, "Name") + " " +StringUtil.Split(filekey, ".")[1]

        string skydome_loc = jmap.getstr(fileobj, "Skydome_tex_file_possible_loc")
        if JContainers.fileExistsAtPath(skydome_loc)
            ConsoleUtil.PrintMessage("Found "+skydome_loc)
            jmap.setstr(retobj, "icon_loc", skydome_loc)
            jmap.setint(retobj, "icon_exists", true as int)
        endif

        jmap.setobj(p, modNameThing, retobj)
        filekey = jmap.nextkey(y, filekey)
    endwhile

    jvalue.writetofile(p, "data/interface/MetaSkillsMenu/MSMData.json")
endfunction

event OpenMenu(string eventName, string strArg, float numArg, Form sender)
    UI.OpenCustomMenu("MetaSkillsMenu/CustomMetaMenu")
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