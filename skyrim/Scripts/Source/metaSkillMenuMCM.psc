Scriptname metaSkillMenuMCM extends SKI_ConfigBase
{Meta Skills Menu MCM}

; code

metaSkillMenuScript property metaSkillMenuMain auto

int OpenCustomSkillMenuKeycode = 0

event OnConfigInit()

endEvent

Event OnPageReset(string page)
    AddHeaderOption("KeyBinds")
    AddKeyMapOptionST("RebindCSMKeycode", "Show Custom Skills Menu", OpenCustomSkillMenuKeycode)
endEvent

state RebindCSMKeycode
    event OnKeyMapChangeST(int keyCode, string conflictControl, string conflictName)
        unregisterforallkeys()
        registerforkey(OpenCustomSkillMenuKeycode)
    endevent
endState

Event OnKeyDown(int keycode)
    If (keycode == OpenCustomSkillMenuKeycode) && !UI.IsMenuOpen("CustomMenu")
        metaSkillMenuMain.doOpenMenu()
    endif
endEvent