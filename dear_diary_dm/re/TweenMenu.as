import gfx.io.GameDelegate;
import gfx.managers.FocusHandler;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import Shared.GlobalFunc;
import Components.Meter;
import mx.utils.Delegate;
import skyui.util.Tween;
import skse;

class TweenMenu extends MovieClip
{
	static var FrameToLabelMap:Array = ["None", "Skills", "Magic", "Inventory", "Map", "CustomSkills"];
	static var BG_ALPHA = 100;
	/*Stage Elements */
	var BottomBarTweener_mc:MovieClip;
	var ItemsInputRect:MovieClip;
	var MagicInputRect:MovieClip;
	var MapInputRect:MovieClip;
	var Selections_mc:MovieClip;
	var SkillsInputRect:MovieClip;
	var Background: MovieClip;
	var CustomSkillsInputRect:MovieClip;
	var hint_cskill:TextField;

	/* Variables */
	var bClosing:Boolean;
	var bLevelUp:Boolean;
	var LevelMeter:Meter;

	function TweenMenu()
	{
		super();
		Selections_mc = Selections_mc;
		BottomBarTweener_mc = BottomBarTweener_mc;
		bClosing = false;
		bLevelUp = false;
		var datafile = new LoadVars();//_loc3_
		datafile.load("deardiary_dm/config.txt");
		datafile.onData = function(str)
		{
			TweenMenu.BG_ALPHA = parseFloat(TweenMenu.ParseConfig(str, "fTabMenuAlpha"));
		};
	}

	function InitExtensions():Void
	{
		GameDelegate.addCallBack("StartOpenMenuAnim",this,"StartOpenMenuAnim");
		GameDelegate.addCallBack("StartCloseMenuAnim",this,"StartCloseMenuAnim");
		GameDelegate.addCallBack("ShowMenu",this,"ShowMenu");
		GameDelegate.addCallBack("HideMenu",this,"HideMenu");
		GameDelegate.addCallBack("ResetStatsButton",this,"ResetStatsButton");

		LevelMeter = new Meter(BottomBarTweener_mc.BottomBar_mc.LevelProgressBar);
		FocusHandler.__get__instance().setFocus(this,0);
		Shared.GlobalFunc.SetLockFunction();

		SkillsInputRect.onRollOver = function()
		{
			_parent.onInputRectMouseOver(1);
		};
		SkillsInputRect.onMouseDown = function()
		{
			if (Mouse.getTopMostEntity() == this)
			{
				_parent.onInputRectClick(1);
			}
		};
		MagicInputRect.onRollOver = function()
		{
			_parent.onInputRectMouseOver(2);
		};
		MagicInputRect.onMouseDown = function()
		{
			if (Mouse.getTopMostEntity() == this)
			{
				_parent.onInputRectClick(2);
			}
		};
		ItemsInputRect.onRollOver = function()
		{
			_parent.onInputRectMouseOver(3);
		};
		ItemsInputRect.onMouseDown = function()
		{
			if (Mouse.getTopMostEntity() == this)
			{
				_parent.onInputRectClick(3);
			}
		};
		MapInputRect.onRollOver = function()
		{
			_parent.onInputRectMouseOver(4);
		};
		MapInputRect.onMouseDown = function()
		{
			if (Mouse.getTopMostEntity() == this)
			{
				_parent.onInputRectClick(4);
			}
		};
		CustomSkillsInputRect.onRollOver = function()
		{
			_parent.onInputRectMouseOver(5);
		};
		CustomSkillsInputRect.onMouseDown = function()
		{
			if (Mouse.getTopMostEntity() == this)
			{
				_parent.onInputRectClick(5);
			}
		};
	}

	function onInputRectMouseOver(aiSelection:Number):Void
	{
		if (!bClosing && aiSelection == 5)
		{
			Selections_mc.gotoAndStop(TweenMenu.FrameToLabelMap[aiSelection]);
			GameDelegate.call("HighlightMenu", [1]);
		}
		if (!bClosing && Selections_mc._currentframe - 1 != aiSelection)
		{
			Selections_mc.gotoAndStop(TweenMenu.FrameToLabelMap[aiSelection]);
			GameDelegate.call("HighlightMenu", [aiSelection]);
		}
	}

	function onInputRectClick(aiSelection:Number):Void
	{
		if (aiSelection == 5)
		{
			GameDelegate.call("PlaySound", ["UISkillsForward"]);
			handleCustomSkillMenuOpen();
			return;
		}
		if (bClosing)
		{
			return;
		}
		GameDelegate.call("OpenHighlightedMenu", [aiSelection]);
	}

	function ResetStatsButton():Void
	{
		Selections_mc.SkillsText_mc.textField.SetText("$SKILLS");
		bLevelUp = false;
	}

	function StartOpenMenuAnim():Void
	{
		if (arguments[0])
		{
			Selections_mc.SkillsText_mc.textField.SetText("$LEVEL UP");
			bLevelUp = true;
		}
		else
		{
			bLevelUp = false;
		}
		gotoAndPlay("startExpand");
		BottomBarTweener_mc._alpha = 100;
		if (arguments[1] != undefined)
		{
			BottomBarTweener_mc.BottomBar_mc.DateText.SetText(arguments[1]);
			BottomBarTweener_mc.BottomBar_mc.DateText.textAutoSize = "shrink";
			BottomBarTweener_mc.gotoAndPlay("startExpand");
		}
		BottomBarTweener_mc.BottomBar_mc.LevelNumberLabel.textAutoSize = "shrink";
		BottomBarTweener_mc.BottomBar_mc.LevelNumberLabel.SetText(arguments[2]);
		LevelMeter.SetPercent(arguments[3]);
	}

	function onFinishOpenMenuAnim():Void
	{
		GameDelegate.call("OpenAnimFinished",[]);
		Background._alpha = TweenMenu.BG_ALPHA;
	}

	function StartCloseMenuAnim():Void
	{
		gotoAndPlay("endExpand");
		BottomBarTweener_mc.gotoAndPlay("endExpand");
		Background._alpha = 0;
	}

	function ShowMenu():Void
	{
		gotoAndStop("showMenu");
		BottomBarTweener_mc._alpha = 100;
		Background._alpha = 100;
		GameDelegate.call("HighlightMenu",[1]);
	}

	function HideMenu():Void
	{
		gotoAndStop("hideMenu");
		BottomBarTweener_mc._alpha = 0;
		Background._alpha = 0;
	}

	function onCloseComplete():Void
	{
		GameDelegate.call("CloseMenu",[]);
	}

	function handleInput(details:InputDetails, pathToFocus:Array):Boolean
	{
		if (!bClosing && GlobalFunc.IsKeyPressed(details))
		{
			var menuFrameIdx:Number = 0;
			if (details.navEquivalent == NavigationCode.UP)
			{
				menuFrameIdx = 1;
			}
			else if (details.navEquivalent == NavigationCode.GAMEPAD_X)
			{
				menuFrameIdx = 5;
			}
			else if (details.navEquivalent == NavigationCode.LEFT)
			{
				menuFrameIdx = 2;
			}
			else if (details.navEquivalent == NavigationCode.RIGHT)
			{
				menuFrameIdx = 3;
			}
			else if (details.navEquivalent == NavigationCode.DOWN)
			{
				menuFrameIdx = 4;
			}

			if (menuFrameIdx > 0)
			{
				if (menuFrameIdx == 5 && menuFrameIdx == Selections_mc._currentframe - 1)
				{
					GameDelegate.call("PlaySound",["UISkillsForward"]);
					handleCustomSkillMenuOpen();
				}
				else if (menuFrameIdx == Selections_mc._currentframe - 1)
				{
					GameDelegate.call("OpenHighlightedMenu",[menuFrameIdx]);
				}
				else if (menuFrameIdx == 5)
				{
					Selections_mc.gotoAndStop(TweenMenu.FrameToLabelMap[menuFrameIdx]);
					GameDelegate.call("HighlightMenu",[1]);
				}
				else
				{
					Selections_mc.gotoAndStop(TweenMenu.FrameToLabelMap[menuFrameIdx]);
					GameDelegate.call("HighlightMenu",[menuFrameIdx]);
				}
			}
			else if (details.navEquivalent == NavigationCode.ENTER && Selections_mc._currentframe > 1)
			{
				GameDelegate.call("OpenHighlightedMenu",[Selections_mc._currentframe - 1]);
			}
			else if (details.navEquivalent == NavigationCode.TAB)
			{
				StartCloseMenuAnim();
				GameDelegate.call("StartCloseMenu",[]);
				bClosing = true;
			}
		}

		if (bLevelUp)
		{
			Selections_mc.SkillsText_mc.textField.SetText("$LEVEL UP");
		}
		return true;
	}

	function handleCustomSkillMenuOpen():Void
	{
		GameDelegate.call("HighlightMenu",[5]);
		var onCompleteTimer:Function = Delegate.create(this, function ()
		{
		skse.SendModEvent("MetaSkillMenu_Open");
		HideMenu();
		//skse.CloseMenu("tweenmenu");
		});
		var timer:Number = setTimeout(Delegate.create(this, onCompleteTimer), 600);
	}

	static function trim(str):String
	{
		var i = 0;//_loc2_
		var cursor = str.length - 1;//_loc1_
		while (str.charCodeAt(i) < 33)
		{
			i = i + 1;
		}
		while (str.charCodeAt(cursor) < 33)
		{
			cursor = cursor - 1;
		}
		return str.substring(i, cursor + 1);
	}

	static function ParseConfig(str, par):String
	{
		var configString = str.split("\n");//_loc3_
		var i = 0;//_loc4_
		var _loc5_ = 0;//not sure what this is for, could be compiler generated?
		while (i < configString.length)
		{
			if (configString[i].charAt(0) != "#")
			{
				var _loc6_ = TweenMenu.trim(configString[i]);
				var _loc7_ = _loc6_.indexOf("=");
				var _loc8_ = _loc6_.substring(0, _loc7_);
				var _loc9_ = TweenMenu.trim(_loc8_);
				if (_loc9_ == par)
				{
					_loc5_ = i;
					break;
				}
			}
			i += 1;
		}
		var _loc10_ = TweenMenu.trim(configString[_loc5_]);
		var _loc11_ = _loc10_.indexOf("=");
		var _loc12_ = _loc10_.substring(_loc11_ + 1, _loc10_.length);
		return TweenMenu.trim(_loc12_);
	}
}

//         if (menuFrameIdx > 0) {
//            if (menuFrameIdx != Selections_mc._currentframe - 1) {
//               elections_mc.gotoAndStop(TweenMenu.FrameToLabelMap[menuFrameIdx]);
//               GameDelegate.call("HighlightMenu",[menuFrameIdx]);
//            }
//            else
//            {
//               GameDelegate.call("OpenHighlightedMenu",[menuFrameIdx]);
//            }
//         }
//         else if(details.navEquivalent == gfx.ui.NavigationCode.ENTER && Selections_mc._currentframe > 1)
//         {
//            GameDelegate.call("OpenHighlightedMenu",[Selections_mc._currentframe - 1]);
//         }
//         else if(details.navEquivalent == gfx.ui.NavigationCode.TAB)
//         {
//            StartCloseMenuAnim();
//            GameDelegate.call("StartCloseMenu",[]);
//            bClosing = true;
//         }
//      }
//      if(bLevelUp)
//      {
//         Selections_mc.SkillsText_mc.textField.SetText("$LEVEL UP");
//      }