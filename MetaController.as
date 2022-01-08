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
	var option0:MovieClip;

	var CenterMouseOver:MovieClip;
	var LeftMouseOver:MovieClip;
	var RightMouseOver:MovieClip;
	var ExitMouseOver:MovieClip;
	var currentSelection:Number;
	var selection_shine:MovieClip;
	var left_shine:MovieClip;
	var right_shine:MovieClip;
	var exit_shine:MovieClip;

	var menuMoving:Boolean;
	var id:Boolean;

	/* Variables */

	function MetaController()
	{
		super();
		id = true;
		this._visible = false;;
		menuMoving = false;
		currentSelection = 0;
		selection_shine._alpha = 0;
		left_shine._alpha = 0;
		right_shine._alpha = 0;
		exit_shine._alpha = 0;
		
		option0 = OptionsContainer.option0;

		FocusHandler.instance.setFocus(this,0);

		CenterMouseOver.onRollOver = function()
		{
			_parent.onInputRectMouseOver(1);
		};
		CenterMouseOver.onMouseDown = function()
		{
			if (Mouse.getTopMostEntity() == this)
			{
				_parent.onInputRectClick(1);
			}
		};
		LeftMouseOver.onRollOver = function()
		{
			_parent.onInputRectMouseOver(2);
		};
		LeftMouseOver.onMouseDown = function()
		{
			if (Mouse.getTopMostEntity() == this)
			{
				_parent.onInputRectClick(2);
			}
		};
		RightMouseOver.onRollOver = function()
		{
			_parent.onInputRectMouseOver(3);
		};
		RightMouseOver.onMouseDown = function()
		{
			if (Mouse.getTopMostEntity() == this)
			{
				_parent.onInputRectClick(3);
			}
		};
		ExitMouseOver.onRollOver = function()
		{
			_parent.onInputRectMouseOver(4);
		};
		ExitMouseOver.onMouseDown = function()
		{
			if (Mouse.getTopMostEntity() == this)
			{
				_parent.onInputRectClick(4);
			}
		};
	}
	
	private function onLoad():Void
	{
		GameDelegate.call("PlaySound",["UIMenuBladeOpen"]);
		getData("MSMData.json");
	}
	
	public function readyToShow(): Void
	{
		this._visible = true;
	}

	private function getData(pathToJsonFile:String):Void
	{
		var openData:LoadVars = new LoadVars();
		openData.onLoad = function(success:Boolean)
		{
			if (!success)
			{
				trace("Couldn't find the file.");
			}
		};
		openData.onData = function(jsonData)
		{
			var self:MovieClip = _root.MetaController_mc;
			var o:Object = JSON.parse(jsonData);
			var i;
			
			var size = -1; // this is dumb.
			for (i in o)
			{
				size++;
			}
			
			self.OptionsContainer.setTotalCount(size);
			
			for (i in o)
			{
				var jcallbackName = i;
				var jname = o[i]["Name"];
				var jdescription = o[i]["Description"];
				var jiconloc;
				if (o[i]["icon_exists"] == 1)
				{
					jiconloc = o[i]["icon_loc"];
				}
				//trace(jcallbackName + " | Name: " + jname + " | Desc: " + jdescription + " | iconloc: " + jiconloc);
				self.OptionsContainer.setOptionObjectInfo(size, jname, jdescription, jiconloc, jcallbackName);
				size--;
			}
			self.readyToShow();
		};
		openData.load(pathToJsonFile);
	}

	function InitExtensions():Void
	{

	}
	
	function onInputRectMouseOver(aiSelection:Number):Void
	{
		var shineAlpha = 5;
		
		if (aiSelection == 1)
		{
			selection_shine._alpha = shineAlpha;
			left_shine._alpha = 0;
			right_shine._alpha = 0;
			exit_shine._alpha = 0;
		}
		else if (aiSelection == 2)
		{
			if (currentSelection <= 0){
				return
			}
			selection_shine._alpha = 0;
			left_shine._alpha = shineAlpha;
			right_shine._alpha = 0;
			exit_shine._alpha = 0;
		}
		else if (aiSelection == 3)
		{
			if (currentSelection >= OptionsContainer.totalOptions){
				return
			}
			selection_shine._alpha = 0;
			left_shine._alpha = 0;
			right_shine._alpha = shineAlpha;
			exit_shine._alpha = 0;
		}
		else if (aiSelection == 4)
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
				moveSelection(-1);
			}
			else if (aiSelection == 3)
			{
				moveSelection(1);
			}
			else if (aiSelection == 1)
			{
				OpenCustomSkillMenu();
			}
		}
		if (aiSelection == 4)
		{
			doClose();
		}
	}
	
	function handleInput(details: InputDetails, pathToFocus: Array): Void
	{
		
		if (!menuMoving && GlobalFunc.IsKeyPressed(details)){
			trace(details);
			if (details.navEquivalent == NavigationCode.UP || details.navEquivalent == NavigationCode.GAMEPAD_X || details.navEquivalent == NavigationCode.GAMEPAD_A)
			{
				OpenCustomSkillMenu();
			}
			else if (details.navEquivalent == NavigationCode.LEFT)
			{
				moveSelection(-1);
			}
			else if (details.navEquivalent == NavigationCode.RIGHT)
			{
				moveSelection(1);
			}
			else if (details.navEquivalent == NavigationCode.DOWN || details.navEquivalent == NavigationCode.GAMEPAD_B)
			{
				doClose();
			}
		}
	}
	
	function doClose(): Void
	{
		menuMoving = true;
		var onCompleteMove:Function = Delegate.create(this, function ()
		{
			GameDelegate.call("PlaySound",["UIMenuBladeClose"]);
			skse.SendModEvent("MetaSkillMenu_Close");
			skse.CloseMenu("CustomMenu");
		});
		Tween.LinearTween(this,"_y",this._x,-400,0.2,onCompleteMove);
		Tween.LinearTween(this,"_alpha", this._alpha, 0, 0.2);
	}

	function moveSelection(direction:Number):Void
	{
		if (direction == -1) //left
		{
			if (currentSelection <= 0){
					return;
				} else
				{
					currentSelection--;
				}
			var desired_x = OptionsContainer._x + 366;
			left_shine._alpha = 15;
		}
		if (direction == 1) //right
		{
			if (currentSelection >= OptionsContainer.totalOptions){
				return;
			} else {
				currentSelection++;
			}
			var desired_x = OptionsContainer._x - 366;
			right_shine._alpha = 15;
		}
		GameDelegate.call("PlaySound",["UIInventorySlide"]);

		var onCompleteMove:Function = Delegate.create(this, function ()
		{
			menuMoving = false;
			left_shine._alpha = 0;
			right_shine._alpha = 0;
		});

		menuMoving = true;
		Tween.LinearTween(OptionsContainer,"_x",OptionsContainer._x,desired_x,0.2,onCompleteMove);
	}

	function OpenCustomSkillMenu():Void
	{
		var optionCallbackKey:String = OptionsContainer.getOptionCallback(currentSelection);
		var onCompleteMove:Function = Delegate.create(this, function ()
		{
			GameDelegate.call("PlaySound",["UIMenuBladeClose"]);
			skse.SendModEvent("MetaSkillMenu_Selection", optionCallbackKey);
			skse.CloseMenu("TweenMenu");
		});
		Tween.LinearTween(this,"_y",this._y,800,0.3,onCompleteMove);
		Tween.LinearTween(this,"_alpha", this._alpha, 0, 0.3);

	}









}