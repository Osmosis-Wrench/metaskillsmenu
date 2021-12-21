import gfx.io.GameDelegate;
import gfx.managers.FocusHandler;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import Shared.GlobalFunc;
import Components.Meter;
import skse;

class OptionCS extends MovieClip
{
  /*Stage Elements */
	
  /* Variables */
	public var GraphicHolder: MovieClip;

	function OptionCS()
	{
		super();
		trace(this);
	}
	public function poop(): String
	{
		return "test";
	}
	function test(): Void
	{
		trace(3);
	}
	
	function loadCustomContent(): Void
	{
		trace(1);
		//var mcHolder:MovieClip = createEmptyMovieClip("mcHolder", getNextHighestDepth());
		//var mcLoader:MovieClipLoader = new MovieClipLoader();
		//mcLoader.addListener(this);
		//mcLoader.loadClip("image.jpg", mcHolder);
	}
}