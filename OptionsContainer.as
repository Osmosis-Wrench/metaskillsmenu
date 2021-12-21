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
	var option0:MovieClip;

	function OptionsContainer()
	{
		super();
		var count = 1;
		while(count <= 100){
			this.attachMovie('Option', 'option'+count, this.getNextHighestDepth());
			var thisOne = this["option"+count];
			var lastOne = this["option"+(count - 1)];
			thisOne._y = lastOne._y;
			thisOne._x = lastOne._x + lastOne._width;
			trace(count);
			count++;
		}
		//this.attachMovie('Option','option1',this.getNextHighestDepth());
		//trace(this["option"+"1"]);
		//option1._x = option0._x + option0._width;
		//option1._y = option0._y;
	}
}