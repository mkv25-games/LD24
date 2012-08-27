package character;

/**
 * ...
 * @author Markavian
 */

class CharacterType 
{
	public var asset:String;
	
	public static var HUMAN:CharacterType;
	public static var WEREWOLF:CharacterType;
	public static var VAMPIRE:CharacterType;
	public static var KITTEH:CharacterType;
	public static var TENTACRUEL:CharacterType;
	public static var GHOST:CharacterType;
	
	public static function instantiate():Void {
		var ext:String = "_x0.4.png";
		HUMAN = new CharacterType("img/human" + ext, "img/decal_pow.png", "audio/pow.mp3",
			1.0, 3.0, 1.0, 5.0);
		WEREWOLF = new CharacterType("img/werewolf" + ext, "img/decal_graw.png", "audio/graw.mp3",
			0.5, 4.0, 2.0, 5.0);
		VAMPIRE = new CharacterType("img/vampire" + ext, "img/decal_bite.png", "audio/mwuhaha.mp3",
			1.5, 5.0, 2.0, 5.0);
		KITTEH = new CharacterType("img/kitteh" + ext, "img/decal_meow.png", "audio/meow.mp3",
			0.8, 5.0, 1.0, 5.0);
		TENTACRUEL = new CharacterType("img/tentacruel" + ext, "img/decal_nom.png", "audio/bite.mp3",
			0.3, 9.0, 2.5, 6.0);
		GHOST = new CharacterType("img/ghost" + ext, "img/decal_ghost.png", "audio/hwoah.mp3",
			2.0, 5.0, 1.0, 5.0);
	}
	
	public var speed:Float;
	public var damage:Float;
	public var armour:Float;
	public var health:Float;
	public var decal:String;
	public var audio:String;
	
	public function new(asset:String, decal:String, audio:String, speed:Float, damage:Float, armour:Float, health:Float) 
	{
		this.asset = asset;
		
		this.speed = speed;
		this.damage = damage;
		this.armour = armour;
		this.health = health;
		this.decal = decal;
		this.audio = audio;
	}
	
}