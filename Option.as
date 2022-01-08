import gfx.io.GameDelegate;
import gfx.managers.FocusHandler;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import Shared.GlobalFunc;
import Components.Meter;
import flash.display.DisplayObject;
import skse;

class Option extends MovieClip
{
	/*Stage Elements */

	/* Variables */
	var Option_GraphicHolder:MovieClip;
	var backup: MovieClip;
	var Option_Name:TextField;
	var Option_Description:TextField;
	var Option_callbackKeyName: String;

	function Option()
	{
		super();
	}

	public function defineOption(optionName:String, optionDescription:String, image_source:String, callbackKeyName:String):Void
	{
		optionName != null ? Option_Name.text = optionName : Option_Name.text = "FAIL: No Skill Name";
		optionDescription != null ? Option_Description.text = optionDescription : Option_Description.text = "A Custom Skill Tree";
		callbackKeyName != null ? Option_callbackKeyName = callbackKeyName : Option_Description.text = "FAIL: NO CALLBACK KEY GENERATED";
		if (image_source != null){
			loadCustomContent(image_source);
		}
	}
	
	public function loadCustomContent(a_source:String): Void
	{
		var holder_x = 0.15;
		var holder_y = -6.7;
		var holder_width = 250;
		var holder_height = 250;
		
		var imageListener:Object = new Object();
		imageListener.onLoadInit   = function(target_mc:MovieClip) {
			target_mc._width = holder_width;
			target_mc._height = holder_height;
			Option_GraphicHolder._x = Math.round(holder_x + (holder_width - target_mc._width)/2);
			Option_GraphicHolder._y = Math.round(holder_y + (holder_height - target_mc._height)/2);
			target_mc._x = target_mc._x-125;
			target_mc._y = target_mc._y-110;
		};
		var imageLoader:MovieClipLoader = new MovieClipLoader();
		imageLoader.addListener(imageListener);
		skse.SendModEvent("debug123", "./../../../"+a_source);
		imageLoader.loadClip("./../../../"+a_source, Option_GraphicHolder);
	}
}