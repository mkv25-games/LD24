package character;
import nme.display.Sprite;
import nme.display.Tilesheet;
import nme.display.BitmapData;
import nme.geom.Rectangle;

/**
 * ...
 * @author Markavian
 */

class CharacterTilesheet extends Tilesheet
{
	var frame:Array<Float>;
	
	public function new(bitmap:BitmapData, scale:Float = 0.4) 
	{
		super(bitmap);
		var boxes = {
			head:{id:0, box:[10,10,130,150]},
			mouth:{id:1, box:[10,170,130,50]},
			torso1:{id:2, box:[150,10,150,120]},
			torso2:{id:3, box:[310,10,150,120]},
			torso3:{id:4, box:[470,10,150,120]},
			legs1:{id:5, box:[155,145,140,70]},
			legs2:{id:6, box:[315,145,140,70]},
			legs3:{id:7, box:[475,145,140,70]},
			eyes1:{id:8, box:[630,10,130,50]},
			eyes2:{id:9, box:[630,70,130,50]},
			eyes3: { id:10, box:[630, 130, 130, 50] }
		};
		
		var fields = Reflect.fields(boxes);
		var boxmap = [];
		for (field in fields) {
			var part = Reflect.field(boxes, field);
			var box = part.box;
			boxmap[part.id] = box;
		}
		
		var s = scale;
		for (box in boxmap) {			
			addTileRect(new Rectangle(box[0] * s, box[1] * s, box[2] * s, box[3] * s));
		}
	
		frame = new Array<Float>();
		frame.push(0);
		frame.push(0);
		frame.push(0);
		frame.push(0);
		frame.push(0);
		frame.push(0);
		frame.push(0);
		frame.push(0);
		frame.push(0);
	}
	
	public function drawPart(sprite:Sprite, id:Int, x:Float, y:Float, scale:Float, alpha:Float):Void {
		// positiong
		frame[0] = x;
		frame[1] = y;
		frame[2] = id;
		
		// scale rotation
		frame[3] = scale;
		frame[4] = 0;
		
		// rgb
		frame[5] = 255;
		frame[6] = 255;
		frame[7] = 255;
		
		// alpha
		frame[8] = alpha;
		
		drawTiles(sprite.graphics, frame, true, Tilesheet.TILE_SCALE | Tilesheet.TILE_ROTATION | Tilesheet.TILE_ALPHA | Tilesheet.TILE_RGB); 
	}
}