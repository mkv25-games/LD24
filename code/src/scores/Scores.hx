package scores;
import core.Game;
import nme.display.Sprite;

/**
 * ...
 * @author Markavian
 */

class Scores 
{
	public var artwork:Sprite;
	
	var panels:Array<ScoresPanel>;
	
	var score:ScoresPanel;
	var combo:ScoresPanel;
	var armour:ScoresPanel;
	var health:ScoresPanel;
	var damage:ScoresPanel;
	var level:ScoresPanel;
	var kills:ScoresPanel;
	
	public function new() 
	{
		artwork = new Sprite();
		
		panels = new Array<ScoresPanel>();
		
		createChildren();
		attachEvents();
	}
	
	public function update():Void {
		var game = Game.map;
		
		score.setScore(game.level.model.score);
		combo.setScore(game.level.model.combos, "x ");
		armour.setScore(game.player.character.armour);
		health.setScore(game.player.character.health);
		damage.setScore(game.player.character.damage);
		level.setScore(game.player.level);
		kills.setScore(game.player.kills);
	}
	
	function createChildren():Void {
		score = createPanel("img/title_score_scores.png", 290, -190);
		combo = createPanel("img/title_score_combo.png", 260, -20);
		armour = createPanel("img/title_score_armour.png", 280, 190);
		health = createPanel("img/title_score_health.png", 0, 150);
		damage = createPanel("img/title_score_damage.png", -280, 190);
		level = createPanel("img/title_score_level.png", -260, -20);
		kills = createPanel("img/title_score_kills.png", -290, -190);
	}
	
	function attachEvents():Void {
		
	}
	
	function createPanel(asset:String, x:Float, y:Float):ScoresPanel {
		var panel = new ScoresPanel(asset);
		panel.setScore(9999);
		
		panel.artwork.x = x;
		panel.artwork.y = y;
		
		artwork.addChild(panel.artwork);
		panels.push(panel);
		
		return panel;
	}
}