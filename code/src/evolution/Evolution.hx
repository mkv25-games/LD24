package evolution;
import character.Character;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.actuators.GenericActuator;
import com.eclecticdesignstudio.motion.easing.Bounce;
import com.eclecticdesignstudio.motion.easing.Quad;
import core.Game;
import nme.Assets;
import nme.display.Sprite;
import nme.display.Bitmap;
import nme.geom.Point;

/**
 * ...
 * @author Markavian
 */

class Evolution 
{
	public var artwork:Sprite;
	public var boxArtwork:Sprite;
	public var evolutionFilled(checkEvolution, null):Bool;
	
	var evolutionArtwork:Sprite;
	var bitmap:Bitmap;
	var boxes:Array<EvolutionBox>;
	var boxPositions:Array<Dynamic>;
	var evolution:List<Character>;

	public function new() 
	{
		artwork = new Sprite();
		boxArtwork = new Sprite();
		evolutionArtwork = new Sprite();
		
		bitmap = new Bitmap();
		boxes = new Array<EvolutionBox>();
		boxPositions = cast [
			{x:-141.55, y:-211.5}, 
			{x:-45.6, y:-225.5}, 
			{x:46.4, y:-225.5}, 
			{x:144.4, y:-211.5}, 
			{x:226.4, y:-181}, 
			{x:287.4, y:-143}, 
			{x:339.4, y:-93}, 
			{x:367.4, y:-32}, 
			{x:367.4, y:27}, 
			{x:343.4, y:82}, 
			{x:298.4, y:129}, 
			{x:236.4, y:169}, 
			{x:151.4, y:198.5}, 
			{x:50.4, y:217.5}, 
			{x:-57.6, y:215.5}, 
			{x:-166.55, y:195.5}, 
			{x:-248.55, y:161.5}, 
			{x:-303.55, y:121.5}, 
			{x:-344.55, y:78.5}, 
			{x:-366.55, y:27}, 
			{x:-366.55, y:-30}, 
			{x:-340.05, y:-92}, 
			{x: -287.05, y: -143 },
			{x: -223.05, y: -182 }
		];
		evolution = new List<Character>();
		
		createChildren();
		attachEvents();
	}
	
	function createChildren():Void {
		var bmp = Assets.getBitmapData("img/evolution_ring.png");
		bitmap.bitmapData = bmp;
		bitmap.x = Math.round( -bitmap.width / 2);
		bitmap.y = Math.round( -bitmap.height / 2);
		
		artwork.addChild(bitmap);
		
		for (pos in boxPositions) {
			var box = new EvolutionBox();
			box.artwork.x = pos.x;
			box.artwork.y = pos.y;
			boxes.push(box);
			boxArtwork.addChild(box.artwork);
		}
		
		animateEvolutionIn();
	}
	
	function attachEvents():Void {
		
	}
	
	public function evolvePlayer():Void {
		var player = Game.map.player;
		
		if (evolution.length > 23) {
			var i:Int = 0;
			for(char in evolution) {
				if(i == 3) player.character.headType = char.headType;
				if(i == 7) player.character.torsoType = char.headType;
				if(i == 11) player.character.tailType = char.headType;
				if(i == 14) player.character.legsType = char.headType;
				if(i == 17) player.character.mouthType = char.headType;
				if(i == 23) player.character.eyesType = char.headType;
				i++;
			}
			player.character.updateStats();
			player.character.scale = Math.min(1.0 + player.level * 0.05, 1.5);
		}
		
		Actuate.tween(player.character, 0.8, { scale: 2.0 } ).ease(Quad.easeInOut).onComplete(onPlayerEvolveIn);
	}
	
	function onPlayerEvolveIn():Void {
		var player = Game.map.player;
		Actuate.tween(player.character, 0.8, { scale: 1.0 } ).ease(Quad.easeInOut).delay(0.1);
	}
	
	public function storeEvolution(creature:Character):Void {
		var box = boxes[evolution.length % boxes.length];
		box.setCharacter(creature);
	
		if (evolution.length < 5) {
			creature.setGenome(creature.headType);
		}
		else if (evolution.length < 8) {
			creature.setGenome(creature.torsoType);
		}
		else if (evolution.length < 12) {
			creature.setGenome(creature.tailType);
		}
		else if (evolution.length < 14) {
			creature.setGenome(creature.legsType);
		}
		else if (evolution.length < 17) {
			creature.setGenome(creature.mouthType);
		}
		else if (evolution.length < 24) {
			creature.setGenome(creature.eyesType);
		}
		
		evolution.push(creature);
		tweenEvolution(box, 0.5, 1.0);
		
		Actuate.tween(creature.position, 0.4, {
			x: box.artwork.x,
			y: box.artwork.y
		}).ease(Quad.easeOut);
		
		Game.map.characters.renderCharacters(evolution, evolutionArtwork);
		boxArtwork.addChild(evolutionArtwork);
	}
	
	function checkEvolution():Bool {
		return (evolution.length == boxes.length);
	}
	
	public function clearEvolution():Void {
		while (evolution.length > 0) {
			evolution.pop();
		}
		
		Game.map.characters.renderCharacters(evolution, evolutionArtwork);
		animateEvolutionOut();
	}
	
	public function animateEvolutionIn():Void {
		while (evolution.length > 0) {
			evolution.pop();
		}
		
		var i:Int = 0;
		for (box in boxes) {
			box.clearPart();
			tweenEvolution(box, 0.0, 1.0, i * 0.05);
			i++;
		}
	}
	
	public function animateEvolutionOut():Void {
		var i:Int = 0;
		for (box in boxes) {
			tweenEvolution(box, 1.0, 0.5, i * 0.05);
			i++;
		}

	}
	
	inline function tweenEvolution(box:EvolutionBox, fromScale:Float, toScale:Float, delay:Float=0.0):Void {
		box.artwork.scaleX = box.artwork.scaleY = fromScale;
		Actuate.tween(box.artwork, 1.0, { scaleX: toScale, scaleY: toScale } ).ease(Bounce.easeOut).delay(delay);
	}
	
}