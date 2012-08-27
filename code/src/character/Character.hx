package character;
import nme.geom.Point;

/**
 * ...
 * @author Markavian
 */

class Character 
{
	public var headType:CharacterType;
	public var torsoType:CharacterType;
	public var legsType:CharacterType;
	public var mouthType:CharacterType;
	public var eyesType:CharacterType;
	public var tailType:CharacterType;
	
	public var walkFrame:Int;
	public var scale:Float;
	
	public var position:Point;
	public var movementTarget:Point;
	public var sensoryRange:Float;
	
	public var speed:Float;
	public var damage:Float;
	public var armour:Float;
	public var maxHealth:Float;
	public var health:Float;
	
	public var movementDelayedTime:Int;
	public var spawnTime:Int;
	
	public var moving:Bool;
	public var justSpawned:Bool;
	public var stunned:Bool;
	public var attacking:Bool;
	public var dying:Bool;
	public var dead:Bool;
	
	public function new() {
		position = new Point();
		movementTarget = new Point();
		
		reset();
	}
	
	public function updateStats():Void {
		speed = legsType.speed;
		maxHealth = torsoType.health + headType.health + legsType.health;
		health = maxHealth;
		
		armour = torsoType.armour + headType.armour + legsType.armour;
		damage = torsoType.damage + mouthType.damage;
	}
	
	public function setGenome(type:CharacterType):Void {
		headType = type;
		torsoType = type;
		legsType = type;
		tailType = type;
		mouthType = type;
		eyesType = type;
		
		scale = 1.0;
		
		stunned = false;
		moving = false;
		attacking = false;
		dying = false;
		dead = false;
		
		updateStats();
	}
	
	public function cycleGenome(types:Array<CharacterType>):Void {
		headType = types[Math.round(Math.random() * 1000) % types.length];
		torsoType = types[Math.round(Math.random() * 1000) % types.length];
		legsType = types[Math.round(Math.random() * 1000) % types.length];
		tailType = types[Math.round(Math.random() * 1000) % types.length];
		mouthType = types[Math.round(Math.random() * 1000) % types.length];
		eyesType = types[Math.round(Math.random() * 1000) % types.length];
	
		updateStats();
	}
	
	public function mergeGenomes(typeA:CharacterType, typeB:CharacterType):Void {
		var types = [typeA, typeB];
		cycleGenome(types);
	}
	
	public function reset():Void {
		movementTarget.x = movementTarget.y = 0;
		position.x = position.y = 0;
		
		walkFrame = 0;
		scale = 1.0;
		moving = false;
		sensoryRange = 350;
		
		speed = 2.0;
		damage = 10;
		armour = 10;
		maxHealth = 10;
		health = maxHealth;
	}
	
}