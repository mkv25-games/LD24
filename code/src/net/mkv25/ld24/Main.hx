package net.mkv25.ld24;

import core.Game;
import nme.display.Sprite;
import nme.events.Event;
import nme.Lib;

/**
 * ...
 * @author Markavian
 */

class Main extends Sprite 
{
	
	public function new() 
	{
		super();
		#if iphone
		Lib.current.stage.addEventListener(Event.RESIZE, init);
		#else
		addEventListener(Event.ADDED_TO_STAGE, init);
		#end
	}

	private function init(e) 
	{
		// entry point
	}
	
	static var game:Game;
	static public function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		stage.align = nme.display.StageAlign.TOP_LEFT;
		
		game = new Game();
		game.artwork.x = Math.round(stage.stageWidth / 2);
		game.artwork.y = Math.round(stage.stageHeight / 2);
		Lib.current.addChild(game.artwork);
	}
	
}
