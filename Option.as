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
	public var GraphicHolder: MovieClip;

	function Option()
	{
		super();
		this.loadCustomContent()
	}
	
	function loadCustomContent(): Void
	{
		trace(1);
		var mcHolder:MovieClip = createEmptyMovieClip("mcHolder", getNextHighestDepth());
		var mcLoader:MovieClipLoader = new MovieClipLoader();
		mcLoader.addListener(this);
		mcLoader.loadClip("HandTohandSymbol.dds", mcHolder);
	}
}