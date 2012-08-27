package player;

/**
 * Defines the player interaction 
 * @author Markavian
 */

 import character.CharacterType;
 import com.eclecticdesignstudio.motion.Actuate;
 import com.eclecticdesignstudio.motion.actuators.GenericActuator;
 import com.eclecticdesignstudio.motion.easing.Quad;
 import core.PointMath;
 import nme.geom.Point;

class Player 
{
	public var character:character.Character;
	public var playerAttacked:Bool;
	public var level:Int;
	public var kills:Int;
	
	var movementQueue:Array<Point>;
	var tweening:Bool;
	var goToTarget:Point;
	var tween:IGenericActuator;
	
	public function new() 
	{
		movementQueue = new Array<Point>();
		tweening = false;
		goToTarget = new Point();
		
		character = new character.Character();
		
		reset();
	}
	
	public function goTo(x:Float, y:Float):Void {
		if (tweening) {
			if (movementQueue.length > 0) {
				movementQueue[0].x = x;
				movementQueue[0].y = y;
			}
			else {
				movementQueue.push(new Point(x, y));
			}
			stopMoving();
			return;
		}
		goToTarget.x = x;
		goToTarget.y = y;
		
		var distance = PointMath.distanceBetweenPoints(character.position, goToTarget);
		
		var time = Math.max(0.1, 1.0 - character.speed / 10) * (distance / 100);
		character.moving = true;
		character.attacking = true;
		playerAttacked = false;
		
		tweening = true;
		tween = Actuate.tween(character.position, time, { x: x, y: y } ).ease(Quad.easeOut).onComplete(stopMoving);
	}
	
	function stopMoving():Void {
		if (tween != null) Actuate.stop(tween);
		tween = null;
			
		character.moving = false;
		// character.attacking = false; // makes it too difficult ?
		tweening = false;
		
		checkQueue();
	}
	
	function checkQueue():Void {
		if (movementQueue.length > 0) {
			var pos = movementQueue.pop();
			goTo(pos.x, pos.y);
		}
	}
	
	public function reset():Void {
		character.reset();
		character.setGenome(CharacterType.HUMAN);
		
		playerAttacked = false;
		level = 1;
		kills = 0;
		
		stopMoving();
	}
}