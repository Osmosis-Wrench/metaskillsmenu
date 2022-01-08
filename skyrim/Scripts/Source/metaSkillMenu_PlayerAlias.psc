Scriptname metaSkillMenu_PlayerAlias extends ReferenceAlias
{ReferenceAlias script for MetaSkillMenu}
Quest Property MetaSkillsMenu  Auto

event OnPlayerLoadGame()
    onLoad()
endEvent

function onLoad()
    (MetaSkillsMenu as metaSkillMenuScript).startup()
endfunction