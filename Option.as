import gfx.io.GameDelegate;
import gfx.managers.FocusHandler;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import Shared.GlobalFunc;
import Components.Meter;
import skse;

class Option extends MovieClip
{
  /*Stage Elements */
	
  /* Variables */
  	private var _customContent: MovieClip;
	private var _customContentX: Number = 0;
	private var _customContentY: Number = 0;
	public var GraphicHolder: MovieClip;

	function Option()
	{
		super();
	}
	
	public function loadCustomContent(a_source: String): Void
	{
		var myGraphic: MovieClip = GraphicHolder;
		
		_customContent = myGraphic.createEmptyMovieClip("customContent", this.getNextHighestDepth());
		_customContent._x = _customContentX;
		_customContent._y = _customContentY;
		_customContent.loadMovie(a_source);
	}
}