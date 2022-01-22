Scriptname metaSkillMenuMCM extends SKI_ConfigBase
{Meta Skills Menu MCM}

; code

metaSkillMenuScript property metaSkillMenuMain auto

string hiddenCachePath = "data/interface/MetaSkillsMenu/MSMHidden.json"
string dataPath = "data/interface/MetaSkillsMenu/MSMData.json"

int OpenCustomSkillMenuKeycode = 0
bool test = false

event OnConfigInit()

endEvent

Event OnPageReset(string page)
    AddHeaderOption("KeyBinds: ")
    AddHeaderOption("Hidden: ")
    AddKeyMapOptionST("RebindCSMKeycode", "Show Custom Skills Menu", OpenCustomSkillMenuKeycode)
    SetCursorPosition(3)
    SetCursorFillMode(TOP_TO_BOTTOM)
    
    If (jcontainers.fileExistsAtPath(hiddenCachePath) && jcontainers.fileExistsAtPath(dataPath))
        int data = JValue.ReadFromFile(dataPath)
        String dataKey = JMap.NextKey(data)
        while dataKey
            string csfName = JValue.SolveStr(data, "."+dataKey+".Name")
            bool isHidden = JValue.SolveInt(data, "."+dataKey+".Hidden") as bool
            AddToggleOptionST("ToggleHidden___"+dataKey, csfName, isHidden)
            datakey = JMap.NextKey(data, datakey)
        endwhile
    Else
        AddHeaderOption("Error, CSM database files not found.")
    endif
endEvent

event OnSelectST()
    string[] stateNameFull = StringUtil.Split(GetState(), "___")
    if stateNameFull.Length > 1
        String csfName = stateNameFull[1]
        int data = JValue.ReadFromFile(dataPath)
        int hiddenCache = JValue.ReadFromFile(hiddenCachePath)

        JValue.SolveIntSetter(data, "."+csfName+".Hidden", (!JValue.SolveInt(data, "."+csfName+".Hidden") as bool) as int)
        JValue.SolveIntSetter(hiddenCache, "."+csfName+".Hidden", JValue.SolveInt(data, "."+csfName+".Hidden"))
        SetToggleOptionValueST((JValue.SolveInt(data, "."+csfName+".Hidden") as bool), false, GetState())

        JValue.WriteToFile(data, dataPath)
        JValue.WriteToFile(hiddenCache, hiddenCachePath)
        JValue.Release(data)
        JValue.Release(hiddenCache)
    endif
endEvent

state RebindCSMKeycode
    event OnKeyMapChangeST(int keyCode, string conflictControl, string conflictName)
        unregisterforallkeys()
        OpenCustomSkillMenuKeycode = keyCode
        registerforkey(OpenCustomSkillMenuKeycode)
        SetKeyMapOptionValueST(keyCode)
    endevent
endState

Event OnKeyDown(int keycode)
    If (keycode == OpenCustomSkillMenuKeycode) && !UI.IsMenuOpen("CustomMenu")
        metaSkillMenuMain.doOpenMenu()
    endif
endEvent