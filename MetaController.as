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
	var option1: MovieClip;
	var option2: MovieClip;
	var option3: MovieClip;
	var option4: MovieClip;

	var CenterMouseOver:MovieClip;
	var LeftMouseOver:MovieClip;
	var RightMouseOver:MovieClip;
	var ExitMouseOver:MovieClip;
	var currentSelection: Number;

	var menuMoving:Boolean;

	/* Variables */

	function MetaController()
	{
		super();
		menuMoving = false;
		currentSelection = 0;
		option0 = OptionsContainer.option0;
		
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
		option0.defineOption("Hand To Hand", "Pugilist is specialized in Hand To Hand combat. A true warrior does not needs a sword.", "HandTohandSymbol.dds");
	}
	
	function InitExtensions(): Void
	{
		
	}
	
	function onInputRectMouseOver(aiSelection:Number):Void
	{
		//trace(aiSelection);
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
			Tween.LinearTween(this,"_y",this._x,-250,0.2,onCompleteMove);
			var onCompleteMove:Function = Delegate.create(this, function ()
			{
				skse.CloseMenu("CustomMenu");
			});
		}
	}

	function testTween(direction:Number):Void
	{
		if (direction == 1)
		{
			var desired_x = OptionsContainer._x - 300;
			currentSelection == 4 ? currentSelection = 0 : currentSelection++;
		}
		if (direction == -1)
		{
			var desired_x = OptionsContainer._x + 300;
			currentSelection == 0 ? currentSelection = 4 : currentSelection--;
		}
		trace(currentSelection);

		var onCompleteMove:Function = Delegate.create(this, function ()
		{
		menuMoving = false;
		});

		menuMoving = true;
		Tween.LinearTween(OptionsContainer,"_x",OptionsContainer._x,desired_x,0.2,onCompleteMove);
	}
	
	function OpenCustomSkillMenu(): Void
	{
		trace(420);
	}
























}