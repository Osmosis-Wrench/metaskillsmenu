import gfx.io.GameDelegate;
import gfx.managers.FocusHandler;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import Shared.GlobalFunc;
import Components.Meter;
import skyui.util.Tween;
import mx.utils.Delegate;
import skse;
import JSON;

class MetaController extends MovieClip
{
	static var directionLableMap:Array = ["None", "Center", "Left", "Right", "Exit"];
	/*Stage Elements */
	var OptionsContainer:MovieClip;
	var option0: MovieClip;
	
	var CenterMouseOver:MovieClip;
	var LeftMouseOver:MovieClip;
	var RightMouseOver:MovieClip;
	var ExitMouseOver:MovieClip;
	var currentSelection: Number;
	var selection_shine: MovieClip;
	var left_shine: MovieClip;
	var right_shine: MovieClip;
	var exit_shine: MovieClip;

	var menuMoving:Boolean;

	/* Variables */

	function MetaController()
	{
		super();
		this._visible = false;
		menuMoving = false;
		currentSelection = 0;
		selection_shine._alpha = 0;
		left_shine._alpha = 0;
		right_shine._alpha = 0;
		exit_shine._alpha = 0;
		trace("a" + selection_shine.alpha);
		
		option0 = OptionsContainer.option0;
		GameDelegate.call("PlaySound", ["UIMenuBladeOpenSD"]);
		
		FocusHandler.instance.setFocus(this, 0);
		
		CenterMouseOver.onRollOver = function()
		{
			_parent.onInputRectMouseOver(1);
		};
		CenterMouseOver.onMouseDown = function()
		{
			if (Mouse.getTopMostEntity() == this)
				_parent.onInputRectClick(1);
		};
		LeftMouseOver.onRollOver = function()
		{
			_parent.onInputRectMouseOver(2);
		};
		LeftMouseOver.onMouseDown = function()
		{
			if (Mouse.getTopMostEntity() == this)
				_parent.onInputRectClick(2);
		};
		RightMouseOver.onRollOver = function()
		{
			_parent.onInputRectMouseOver(3);
		};
		RightMouseOver.onMouseDown = function()
		{
			if (Mouse.getTopMostEntity() == this)
				_parent.onInputRectClick(3);
		};
		ExitMouseOver.onRollOver = function()
		{
			_parent.onInputRectMouseOver(4);
		};
		ExitMouseOver.onMouseDown = function()
		{
			if (Mouse.getTopMostEntity() == this)
				_parent.onInputRectClick(4);
		};
	}
	
	private function onLoad(): Void
	{
		GameDelegate.call("PlaySound", ["UIMenuFocus"]);
		skse.SendModEvent("MetaSkillMenu_Open");
		this._visible = true;
		option0.defineOption("Hand To Hand", "Pugilist is specialized in Hand To Hand combat. A true warrior does not needs a sword.", "HandTohandSymbol.dds");
	}
	
	function InitExtensions(): Void
	{
		
	}
	//["None", "Center", "Left", "Right", "Exit"];
	function onInputRectMouseOver(aiSelection:Number):Void
	{
		var shineAlpha = 5;
		if ( aiSelection == 1 )
		{
			selection_shine._alpha = shineAlpha;
			left_shine._alpha = 0;
			right_shine._alpha = 0;
			exit_shine._alpha = 0;
		} else if ( aiSelection == 2 )
		{
			selection_shine._alpha = 0;
			left_shine._alpha = shineAlpha;
			right_shine._alpha = 0;
			exit_shine._alpha = 0;
		} else if ( aiSelection == 3 )
		{
			selection_shine._alpha = 0;
			left_shine._alpha = 0;
			right_shine._alpha = shineAlpha;
			exit_shine._alpha = 0;
		} else if ( aiSelection == 4 )
		{
			selection_shine._alpha = 0;
			left_shine._alpha = 0;
			right_shine._alpha = 0;
			exit_shine._alpha = 15;
		}
	}

	function onInputRectClick(aiSelection:Number):Void
	{
		//trace(aiSelection);
		if (!menuMoving)
		{
			if (aiSelection == 2)
			{
				testTween(-1);
			}
			else if (aiSelection == 3)
			{
				testTween(1);
			}
			else if (aiSelection == 1)
			{
				OpenCustomSkillMenu();
			}
		}
		if ( aiSelection == 4)
		{
			menuMoving = true;
			var onCompleteMove:Function = Delegate.create(this, function ()
			{
				GameDelegate.call("PlaySound", ["UIMenuBladeCloseSD"]);
				skse.SendModEvent("MetaSkillMenu_Close");
				skse.CloseMenu("CustomMenu");
			});
			Tween.LinearTween(this,"_y",this._x,-400,0.2,onCompleteMove);
		}
	}

	function testTween(direction:Number):Void
	{
		if (direction == 1)
		{
			var desired_x = OptionsContainer._x - 366;
			currentSelection == 4 ? currentSelection = 0 : currentSelection++;
		}
		if (direction == -1)
		{
			var desired_x = OptionsContainer._x + 366;
			currentSelection == 0 ? currentSelection = 4 : currentSelection--;
		}
		trace(currentSelection);

		var onCompleteMove:Function = Delegate.create(this, function ()
		{
		menuMoving = false;
		});

		menuMoving = true;
		Tween.LinearTween(OptionsContainer,"_x",OptionsContainer._x,desired_x,0.2,onCompleteMove);
		GameDelegate.call("PlaySound",["UIMenuFocus"]);
	}
	
	function OpenCustomSkillMenu(): Void
	{
		trace(420);
	}
























}