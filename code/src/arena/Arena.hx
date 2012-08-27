package arena;
import nme.display.Sprite;
import nme.Assets;
import nme.display.Bitmap;

/**
 * Represents the arena that creatures enter into
 * @author Markavian
 */

class Arena 
{
	public var artwork:Sprite;

	var bitmap:Bitmap;
	
	public function new() 
	{
		artwork = new Sprite();
		
		createChildren();
		attachEvents();
	}
	
	function createChildren():Void {
		var bmp = Assets.getBitmapData("img/arena.png");
		bitmap = new Bitmap(bmp);
		bitmap.x = Math.round( -bitmap.width / 2);
		bitmap.y = Math.round( -bitmap.height / 2);
		
		artwork.addChild(bitmap);
	}
	
	function attachEvents():Void {
		
	}
	
}