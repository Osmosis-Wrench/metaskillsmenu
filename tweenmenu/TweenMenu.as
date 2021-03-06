import gfx.io.GameDelegate;
import gfx.managers.FocusHandler;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import Shared.GlobalFunc;
import Components.Meter;
import mx.utils.Delegate;
import skyui.util.Tween;
import skse;
import JSON;

class TweenMenu extends MovieClip
{
	static var FrameToLabelMap: Array = ["None", "Skills", "Magic", "Inventory", "Map", "CustomSkills"];
	
  /*Stage Elements */
	var BottomBarTweener_mc: MovieClip;
	var ItemsInputRect: MovieClip;
	var MagicInputRect: MovieClip;
	var MapInputRect: MovieClip;
	var Selections_mc: MovieClip;
	var SkillsInputRect: MovieClip;
	var CustomSkillsInputRect: MovieClip;
	var hint_cskill: TextField;
	var cshint_mc: MovieClip;
	
  /* Variables */
	var bClosing: Boolean;
	var bLevelUp: Boolean;
	var LevelMeter: Meter;

	function TweenMenu()
	{
		super();
		cshint_mc = Selections_mc.cshint_mc;
		cshint_mc._alpha = 100;
		bClosing = false;
		bLevelUp = false;
		getData("MetaSkillsMenu/MSM_FLASH_SETTINGS.json");
	}

	function getData(pathToJsonFile:String):Void
	{
		var openData:LoadVars = new LoadVars();

		openData.onData = function(jsonData)
		{
			if(jsonData)
			{
				var o:Object = JSON.parse(jsonData);
				o["hide_hint"] == 0 ? _root.TweenMenu_mc.cshint_mc._alpha = 100 : _root.TweenMenu_mc.cshint_mc._alpha = 0;
			}
		}

		openData.load(pathToJsonFile);
	}

	function InitExtensions(): Void
	{
		GameDelegate.addCallBack("StartOpenMenuAnim", this, "StartOpenMenuAnim");
		GameDelegate.addCallBack("StartCloseMenuAnim", this, "StartCloseMenuAnim");
		GameDelegate.addCallBack("ShowMenu", this, "ShowMenu");
		GameDelegate.addCallBack("HideMenu", this, "HideMenu");
		GameDelegate.addCallBack("ResetStatsButton", this, "ResetStatsButton");
		
		LevelMeter = new Meter(BottomBarTweener_mc.BottomBar_mc.LevelProgressBar);
		FocusHandler.instance.setFocus(this, 0);
		GlobalFunc.SetLockFunction();
		MovieClip(BottomBarTweener_mc).Lock("B");
		SkillsInputRect.onRollOver = function ()
		{
			trace(1);
			_parent.onInputRectMouseOver(1);
		};
		SkillsInputRect.onMouseDown = function ()
		{
			if (Mouse.getTopMostEntity() == this) 
				_parent.onInputRectClick(1);
		};
		MagicInputRect.onRollOver = function ()
		{
			_parent.onInputRectMouseOver(2);
		};
		MagicInputRect.onMouseDown = function ()
		{
			if (Mouse.getTopMostEntity() == this) 
				_parent.onInputRectClick(2);
		};
		ItemsInputRect.onRollOver = function ()
		{
			_parent.onInputRectMouseOver(3);
		};
		ItemsInputRect.onMouseDown = function ()
		{
			if (Mouse.getTopMostEntity() == this)
				_parent.onInputRectClick(3);
		};
		MapInputRect.onRollOver = function ()
		{
			_parent.onInputRectMouseOver(4);
		};
		MapInputRect.onMouseDown = function ()
		{
			if (Mouse.getTopMostEntity() == this) 
				_parent.onInputRectClick(4);
		};
		CustomSkillsInputRect.onRollOver = function()
		{
			_parent.onInputRectMouseOver(5);
		};
		CustomSkillsInputRect.onMouseDown = function ()
		{
			if (Mouse.getTopMostEntity() == this) 
				_parent.onInputRectClick(5);
		};
	}

	function onInputRectMouseOver(aiSelection: Number): Void
	{
		if (!bClosing && aiSelection == 5){
			Selections_mc.gotoAndStop(TweenMenu.FrameToLabelMap[aiSelection]);
			GameDelegate.call("HighlightMenu", [1]);
		}
		if (!bClosing && Selections_mc._currentframe - 1 != aiSelection) {
			Selections_mc.gotoAndStop(TweenMenu.FrameToLabelMap[aiSelection]);
			GameDelegate.call("HighlightMenu", [aiSelection]);
		}
	}

	function onInputRectClick(aiSelection: Number): Void
	{
		if (aiSelection == 5){
			GameDelegate.call("PlaySound",["UISkillsForward"]);
			handleCustomSkillMenuOpen();
			return;
		}
		if (bClosing) 
			return;
		GameDelegate.call("OpenHighlightedMenu", [aiSelection]);
	}
	
	function ResetStatsButton(): Void
	{
		Selections_mc.SkillsText_mc.textField.SetText("$SKILLS");
		bLevelUp = false;
	}

	function StartOpenMenuAnim(): Void
	{
		if (arguments[0]) {
			Selections_mc.SkillsText_mc.textField.SetText("$LEVEL UP");
			bLevelUp = true;
		} else {
			bLevelUp = false;
		}
		gotoAndPlay("startExpand");
		BottomBarTweener_mc._alpha = 100;
		if (arguments[1] != undefined) {
			BottomBarTweener_mc.BottomBar_mc.DateText.SetText(arguments[1]);
			BottomBarTweener_mc.gotoAndPlay("startExpand");
		}
		BottomBarTweener_mc.BottomBar_mc.LevelNumberLabel.SetText(arguments[2]);
		LevelMeter.SetPercent(arguments[3]);
	}

	function onFinishOpenMenuAnim(): Void
	{
		GameDelegate.call("OpenAnimFinished", []);
	}

	function StartCloseMenuAnim(): Void
	{
		gotoAndPlay("endExpand");
		BottomBarTweener_mc.gotoAndPlay("endExpand");
	}

	function ShowMenu(): Void
	{
		gotoAndStop("showMenu");
		BottomBarTweener_mc._alpha = 100;
		GameDelegate.call("HighlightMenu", [1]);
	}

	function HideMenu(): Void
	{
		gotoAndStop("hideMenu");
		BottomBarTweener_mc._alpha = 0;
	}

	function onCloseComplete(): Void
	{
		GameDelegate.call("CloseMenu", []);
	}
	//static var FrameToLabelMap: Array = ["None", "Skills", "Magic", "Inventory", "Map", "CustomSkills"];
	
	function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{
		if (!bClosing && GlobalFunc.IsKeyPressed(details)) {
			var menuFrameIdx: Number = 0;
			if (details.navEquivalent == NavigationCode.UP) {
				menuFrameIdx = 1;
			} else if (details.navEquivalent == NavigationCode.GAMEPAD_X) {
				menuFrameIdx = 5;
			} else if (details.navEquivalent == NavigationCode.LEFT) {
				menuFrameIdx = 2;
			} else if (details.navEquivalent == NavigationCode.RIGHT) {
				menuFrameIdx = 3;
			} else if (details.navEquivalent == NavigationCode.DOWN) {
				menuFrameIdx = 4;
			}
			
			if (menuFrameIdx > 0) {
				if (menuFrameIdx == 5 && menuFrameIdx == Selections_mc._currentframe - 1)
				{
					GameDelegate.call("PlaySound",["UISkillsForward"]);
					handleCustomSkillMenuOpen();
				}else if (menuFrameIdx == Selections_mc._currentframe - 1) {
					GameDelegate.call("OpenHighlightedMenu", [menuFrameIdx]);
				} else if (menuFrameIdx == 5){
					Selections_mc.gotoAndStop(TweenMenu.FrameToLabelMap[menuFrameIdx]);
					GameDelegate.call("HighlightMenu", [1]);
				}
				else {
					Selections_mc.gotoAndStop(TweenMenu.FrameToLabelMap[menuFrameIdx]);
					GameDelegate.call("HighlightMenu", [menuFrameIdx]);
				}
			} else if (details.navEquivalent == NavigationCode.ENTER && Selections_mc._currentframe > 1) {
				if (Selections_mc._currentframe == 6){
					GameDelegate.call("PlaySound",["UISkillsForward"]);
					handleCustomSkillMenuOpen();
				} else {
					GameDelegate.call("OpenHighlightedMenu",[Selections_mc._currentframe - 1]);
				}
			} else if (details.navEquivalent == NavigationCode.TAB) {
				StartCloseMenuAnim();
				GameDelegate.call("StartCloseMenu", []);
				bClosing = true;
			}
		}
		
		if (bLevelUp) 
			Selections_mc.SkillsText_mc.textField.SetText("$LEVEL UP");
		return true;
	}
	
	function handleCustomSkillMenuOpen():Void
	{
		GameDelegate.call("HighlightMenu", [5]);
		var onCompleteTimer:Function = Delegate.create(this, function ()
		{
			skse.SendModEvent("MetaSkillMenu_Open");
			HideMenu();
			//skse.CloseMenu("tweenmenu");
		});
		var timer:Number = setTimeout(Delegate.create(this, onCompleteTimer), 600)
	}

}
