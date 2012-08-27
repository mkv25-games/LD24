package character;
import flash.display.Graphics;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.display.Tilesheet;
import nme.Lib;

/**
 * ...
 * @author Markavian
 */

class CharacterRenderer 
{
	public var artwork:Sprite;
	public var model:CharacterModel;
	
	private var tilesheets:Hash<CharacterTilesheet>;
	
	private var head:Int = 0;
	private var mouth:Int = 1;
	private var torso1:Int = 2;
	private var torso2:Int = 3;
	private var torso3:Int = 4;
	private var legs1:Int = 5;
	private var legs2:Int = 6;
	private var legs3:Int = 7;
	private var eyes1:Int = 8;
	private var eyes2:Int = 9;
	private var eyes3:Int = 10;
	
	public function new() 
	{
		artwork = new Sprite();
		model = new CharacterModel();
		
		CharacterType.instantiate();
		
		tilesheets = new Hash<CharacterTilesheet>();
	}
	
	public function draw():Void {
		renderCharacters(model.characters, artwork);
	}
	
	public function renderCharacters(characters:List<Character>, artwork:Sprite):Void {
		artwork.graphics.clear();
		
		for (character in characters) {
			drawCharacter(character, artwork);
		}
	}
	
	inline function drawCharacter(character:Character, artwork:Sprite):Void {
		var x:Float = Math.round(character.position.x);
		var y:Float = Math.round(character.position.y);
		var s:Float = 0.5 * character.scale;
		var a:Float = 1.0;
		
		if (character.justSpawned) {
			var spawnAge:Float = Lib.getTimer() - character.spawnTime;
			if (spawnAge < 2000) {
				s = s * (spawnAge / 2000);
			}
			else {
				character.justSpawned = false;
			}
		}
		
		var legs = legs1;
		var eyes = eyes1;
		var torso = torso1;		
		
		if(character.moving) {
			if (character.walkFrame < 5) legs = legs2;
			else legs = legs3;
		}
		if (character.dying) {
			if (character.walkFrame < 5) torso = torso1;
			else torso = torso2;
		}
		else {
			if (character.stunned) {
				eyes = eyes2;
				torso = torso2;
			}
			if (character.attacking) {
				eyes = eyes3;
				torso = torso3;
			}
		}
		
		var xs:Float = 0.4;
		getTilesheet(character.legsType.asset).drawPart(artwork, legs, x - 70 * s * xs, y - 18 * s * xs, s, a);
		getTilesheet(character.torsoType.asset).drawPart(artwork, torso, x - 75 * s * xs, y - 100 * s * xs, s, a);
		getTilesheet(character.headType.asset).drawPart(artwork, head, x - 65 * s * xs, y - 175 * s * xs, s, a);
		getTilesheet(character.eyesType.asset).drawPart(artwork, eyes, x - 65 * s * xs, y - 130 * s * xs, s, a);
		getTilesheet(character.mouthType.asset).drawPart(artwork, mouth, x - 65 * s * xs, y - 100 * s * xs, s, a);
		
		var g:Graphics = artwork.graphics;
		var hs = character.health / character.maxHealth;
		g.beginFill(0xFF0000);
		g.drawRect(x - 40 * xs * s, y - 190 * xs * s, 80 * xs * s, 20 * xs * s);
		g.beginFill(0x33CC00);
		g.drawRect(x - 40 * xs * s, y - 190 * xs * s, 80 * xs * s * hs, 20 * xs * s);
	}
	
	inline function getTilesheet(asset:String):CharacterTilesheet {
		var tilesheet:CharacterTilesheet;
		if (tilesheets.exists(asset)) 
		{
			tilesheet = tilesheets.get(asset);
		}
		else {
			var bitmap = Assets.getBitmapData(asset);
			tilesheet = new CharacterTilesheet(bitmap);
			tilesheets.set(asset, tilesheet);
		}
		
		return tilesheet;
	}
	
	public function reset():Void {
		while (model.characters.length > 0) {
			model.characters.pop();
		}
	}
	
}