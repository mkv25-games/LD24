package evolution;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Sprite;
import nme.Assets;

/**
 * ...
 * @author Markavian
 */

class EvolutionBox 
{
	public var artwork:Sprite;
	public var character:character.Character;
	var bitmap:Bitmap;
	
	public function new() 
	{
		artwork = new Sprite();
		bitmap = new Bitmap();
		artwork.addChild(bitmap);
		
		var part = Assets.getBitmapData("img/evolution_box.png");
		setPart(part);
	}
	
	public function clearPart():Void {
		var part = Assets.getBitmapData("img/evolution_box.png");
		setPart(part);
	}
	
	public function setPart(part:BitmapData):Void {
		bitmap.bitmapData = part;
		
		bitmap.x = -bitmap.width / 2;
		bitmap.y = -bitmap.width / 2;
	}
	
	public function setCharacter(character:character.Character):Void {
		character.position.x = artwork.x;
		character.position.y = artwork.y;
	}
	
}