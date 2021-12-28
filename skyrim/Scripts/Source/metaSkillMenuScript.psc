Scriptname metaSkillMenuScript extends Quest  
{Controller script for MetaSkillMenu}

int property metaSkillsMenuDB
    int function get()
        return JDB.solveObj(".metaSkillsMenuDB.mods")
    EndFunction
    function set(int object)
        JDB.solveObjSetter(".metaSkillsMenuDB.mods", object, true)
    endfunction
endproperty

event OnInit()
    startup()
endEvent

function startup()
    if JContainers.fileExistsAtPath("data\\NetScriptFramework\\Plugins\\CustomSkill.VicHand2Hand.config.txt")
        ConsoleUtil.PrintMessage("poop")
    Else
        ConsoleUtil.PrintMessage("test123")
    endif

    string[] a = JContainers.contentsOfDirectoryAtPath("data\\NetScriptFramework\\Plugins\\", ".txt")
    ConsoleUtil.PrintMessage(a.length)
    int x = JArray.objectWithStrings(a)
    jvalue.writetofile(x, "metaMenuTest1.json")

    int y = JValue.evalLuaObj(x, "return msm.returnSkillTreeObject(jobject)")
    jvalue.writetofile(y, "metaMenuTest2.json")

    string filekey = jmap.nextkey(y)

    int p = Jmap.Object()
    while filekey
        int fileobj = jmap.getobj(y, filekey)
        int retobj = jvalue.deepcopy(fileobj)

        string modNameThing = jmap.getstr(fileobj, "Name") + " " +StringUtil.Split(filekey, ".")[1]

        string skydome = jmap.getstr(fileobj, "Skydome")
        if JContainers.fileExistsAtPath("data\\textures\\"+skydome)
            ConsoleUtil.PrintMessage("Found "+skydome)
            jmap.setstr(retobj, "icon_loc", "data\\textures\\"+skydome)
            jmap.setint(retobj, "Skydome_exists", true as int)
        endif

        jmap.setobj(p, modNameThing, retobj)
        filekey = jmap.nextkey(y, filekey)
    endwhile
    jvalue.writetofile(p, "metaMenuTest3.json")

endfunction
