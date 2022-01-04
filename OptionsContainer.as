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

class OptionsContainer extends MovieClip
{
	var option0: MovieClip;
	var totalOptions: Number;
	
	function OptionsContainer()
	{
		super();
	}

	public function setTotalCount(size:Number):Void
	{
		trace(size);
		var count = 1;
		while (count <= size)
		{
			this.attachMovie('Option','option' + count,this.getNextHighestDepth());
			var thisOne = this["option" + count];
			var lastOne = this["option" + (count - 1)];
			trace(lastOne);
			thisOne._y = lastOne._y;
			thisOne._x = lastOne._x + lastOne._width;
			count++;
		}
		totalOptions = size;
	}
	
	public function setOptionObjectInfo(optionNumber:Number, optionName:String, optionDescription:String, image_source:String, callbackKeyName:String) : Void
	{
		trace(optionNumber);
		var uOption = this["option"+optionNumber];
		uOption.defineOption(optionName, optionDescription, image_source, callbackKeyName);
	}
	
	public function getOptionCallback(optionNumber:Number): String
	{
		trace(optionNumber);
		var uOption = this["option"+optionNumber];
		return uOption.Option_callbackKeyName;
	}
}