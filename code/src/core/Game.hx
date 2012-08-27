package core;
import character.CharacterRenderer;
import character.CharacterType;
import nme.display.FPS;
import nme.events.Event;
import nme.events.MouseEvent;
import player.Player;
import nme.display.Sprite;
import scores.Scores;

/**
 * The Game.
 * @author Markavian
 */

class Game 
{
	public static var map:Game;
	
	public var artwork:Sprite;
	public var audio:Audio;
	
	public var arena:arena.Arena;
	public var evolution:evolution.Evolution;
	public var characters:CharacterRenderer;
	public var player:player.Player;
	public var level:level.Level;
	public var score:Scores;

	public function new() 
	{
		artwork = new Sprite();
		artwork.mouseChildren = false;
		
		audio = new Audio();
		
		instantiateModels();
		
		arena = new arena.Arena();
		evolution = new evolution.Evolution();
		characters = new CharacterRenderer();
		player = new Player();
		level = new level.Level();
		score = new Scores();
		
		createChildren();
		attachEvents();
		
		//artwork.addChild(new FPS());
		
		map = this;
		
		audio.loop("audio/bgm.mp3");
	}
	
	function instantiateModels():Void {
		
	}
	
	function createChildren():Void {
		artwork.addChild(evolution.artwork);
		artwork.addChild(arena.artwork);
		artwork.addChild(evolution.boxArtwork);
		artwork.addChild(characters.artwork);
		artwork.addChild(score.artwork);
		artwork.addChild(level.hud.artwork);
	}
	
	function attachEvents():Void {
		artwork.addEventListener(Event.ENTER_FRAME, update);
		artwork.addEventListener(MouseEvent.CLICK, click);
	}
	
	function update(e:Event):Void {
		level.model.considerOptions();
		
		characters.draw();
		
		score.update();
	}
	
	function click(e:MouseEvent):Void {
		level.model.goHereAndKillShit(e);
	}
}