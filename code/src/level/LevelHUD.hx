package level;
import nme.display.Sprite;

/**
 * ...
 * @author Markavian
 */

class LevelHUD 
{
	public var artwork:Sprite;
	
	public var mainTitle:LevelTitle;
	public var evolvingTitle:LevelTitle;
	public var fightTitle:LevelTitle;
	public var arenaLoadTitle:LevelTitle;
	public var deathTitle:LevelTitle;
	
	public function new() 
	{
		artwork = new Sprite();
		artwork.y = -50;
		
		mainTitle = new LevelTitle("img/title_main.png", "audio/battle_arena_evolution.mp3");
		evolvingTitle = new LevelTitle("img/title_evolving.png", "audio/evolving.mp3");
		fightTitle = new LevelTitle("img/title_fight.png", "audio/fight.mp3");
		arenaLoadTitle = new LevelTitle("img/title_arena_load.png", "audio/arena_load.mp3");
		deathTitle = new LevelTitle("img/title_death.png", "audio/death.mp3");
		
		artwork.addChild(mainTitle.artwork);
		artwork.addChild(evolvingTitle.artwork);
		artwork.addChild(fightTitle.artwork);
		artwork.addChild(arenaLoadTitle.artwork);
		artwork.addChild(deathTitle.artwork);
	}
	
}