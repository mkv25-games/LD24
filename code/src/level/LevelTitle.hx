package level;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Quad;
import core.Game;
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

class LevelTitle 
{
	public var artwork:Sprite;
	
	var audio:String;
	var bitmap:Bitmap;
	var onComplete:Void->Void;
	
	public function new(asset:String, audio:String) 
	{
		artwork = new Sprite();
		this.audio = audio;
		
		bitmap = new Bitmap();
		bitmap.bitmapData = Assets.getBitmapData(asset);
		artwork.addChild(bitmap);
		
		bitmap.x = -bitmap.width / 2;
		bitmap.y = -bitmap.height / 2;
		
		artwork.visible = false;
	}
	
	public function animateIn(onComplete:Void->Void):Void {
		this.onComplete = onComplete;
		artwork.alpha = 0.0;
		artwork.scaleX = artwork.scaleY = 0.0;
		artwork.visible = true;
		Actuate.tween(artwork, 1.0, { scaleX: 1.0, scaleY: 1.0, alpha: 1.0 } ).ease(Quad.easeInOut).onComplete(animateOut);
		
		Game.map.audio.play(audio);
	}
	
	public function animateInOnly(onComplete:Void->Void):Void {
		this.onComplete = onComplete;
		artwork.alpha = 0.0;
		artwork.scaleX = artwork.scaleY = 0.0;
		artwork.visible = true;
		Actuate.tween(artwork, 1.0, { scaleX: 1.0, scaleY: 1.0, alpha: 1.0 } ).ease(Quad.easeInOut).onComplete(onComplete);
		
		Game.map.audio.play(audio);
	}
	
	function animateOut():Void {
		Actuate.tween(artwork, 1.0, { scaleX: 0.0, scaleY: 0.0, alpha: 0.0 } ).ease(Quad.easeInOut).onComplete(complete).delay(1.0);
	}
	
	public function animateOutOnly():Void {
		Actuate.tween(artwork, 1.0, { scaleX: 0.0, scaleY: 0.0, alpha: 0.0 } ).ease(Quad.easeInOut).autoVisible(true);
	}
	
	function complete():Void {
		onComplete();
		artwork.visible = false;
	}
}