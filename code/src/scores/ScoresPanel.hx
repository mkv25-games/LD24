package scores;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.Assets;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;

/**
 * ...
 * @author Markavian
 */

class ScoresPanel 
{
	public var artwork:Sprite;
	
	var bitmap:Bitmap;
	var textbox:TextField;
	
	public function new(asset:String) 
	{
		artwork = new Sprite();
		bitmap = new Bitmap();
		bitmap.bitmapData = Assets.getBitmapData(asset);
		artwork.addChild(bitmap);
		
		bitmap.x = -bitmap.width / 2;
		bitmap.y = -bitmap.height / 2;
		
		textbox = new TextField();
		
		var font = Assets.getFont("fonts/captain.ttf");
		var format = new TextFormat(font.fontName, 40, 0xFFFFFF);
		format.align = TextFormatAlign.CENTER;
		textbox.defaultTextFormat = format;
		textbox.setTextFormat(format);
		textbox.width = bitmap.width;
		textbox.embedFonts = true;
		textbox.x = bitmap.x;
		textbox.y = bitmap.y + 40;
		
		artwork.addChild(textbox);
	}
	
	public function setScore(value:Float, prefix:String=""):Void {
		textbox.text = prefix + Math.round(value);
	}
}