package character;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Quad;
import core.Game;
import core.PointMath;
import nme.Assets;
import nme.display.Bitmap;
import nme.geom.Point;
import nme.Lib;

/**
 * ...
 * @author Markavian
 */

class CharacterModel 
{
	public var characters:List<Character>;
	
	var lastAttackTime:Int;
	
	public function new() 
	{
		characters = new List<Character>();
	}
	
	public function moveAll():Void {
		var player = Game.map.player.character;
		
		for (character in characters) {
			// update walk frame
			character.walkFrame++;
			if (character.walkFrame > 9) character.walkFrame = 0;
			
			// set player target
			if (character == player) {
				// do nothing, handled by tweening
			}
			// set AI target
			else {
				if (character.movementDelayedTime > Lib.getTimer()) {
					// Stay here buddy
					character.moving = false;
				}
				else {
					var distance = PointMath.distanceBetweenPoints(character.position, player.position);
					if (distance > character.sensoryRange) {
						// Stay here buddy
						character.moving = false;
					}
					else {
						character.attacking = false;
						character.stunned = false;
				
						character.movementTarget.x = player.position.x;
						character.movementTarget.y = player.position.y;
						moveCharacter(character);
					}
				}
			}
		}
	}	
	
	inline function moveCharacter(character:Character):Void {
		if (character.justSpawned) {
			// do nothing
		}
		else {
			//calculate distance
			var distance = PointMath.distanceBetweenPoints(character.position, character.movementTarget);
			if (distance < character.speed) {
				// reached target
				character.moving = false;
			}
			else {
				// calculate new position
				var direction:Point = PointMath.normalisedDifferenceVector(character.position, character.movementTarget);
				character.position.x += direction.x * character.speed;
				character.position.y += direction.y * character.speed;
				
				character.moving = true;
			}
		}
	}
	
	public function attackAll():Void {
		var player = Game.map.player;
		var time = Lib.getTimer();
		
		var lastAttacker:Character = null;
		for (attacker in characters) {
			if (attacker == player.character) {
				// chill
			}
			else if (attacker.dead || attacker.dying) {
				// chill
			}
			else {
				var distance = PointMath.distanceBetweenPoints(attacker.position, player.character.position);
				if (distance < 50) {
					if (player.character.attacking) {
						if (lastAttackTime < time - 1000) {
							Game.map.level.model.combos++;
						}
						else {
							Game.map.level.model.combos = 1;
						}
						lastAttackTime = time;
						
						attacker.health = attacker.health - (player.character.damage / Math.max(player.level / 4, 1));
						attacker.movementDelayedTime = Math.round(time + (0.5 + Math.random()) * 2 * 1000);
						Game.map.level.model.score += player.character.damage * Game.map.level.model.combos;
						player.playerAttacked = true;
						attacker.stunned = true;
						
						spawnDecal(player.character.torsoType.decal, attacker.position.x, attacker.position.y - 10);
						Game.map.audio.play(player.character.torsoType.audio, true);
						
						if(attacker.health > 0) {
							var direction = PointMath.normalisedDifferenceVector(player.character.position, attacker.position);
							Actuate.tween(attacker.position, 0.4, {
								x: attacker.position.x + direction.x * player.character.damage * 4,
								y: attacker.position.y + direction.y * player.character.damage * 4
							}).ease(Quad.easeOut);
						}
						else {
							Actuate.stop(attacker.position);
						}
					}
					else if(distance < 20) {
						var canAttack:Bool = (attacker.movementDelayedTime < time) && (distance < 20);
						if (canAttack) {
							attacker.attacking = true;
							if(attacker.damage > player.character.armour)
								player.character.health = player.character.health - (attacker.damage - player.character.armour);
							attacker.movementDelayedTime = Math.round(time + (0.2 + Math.random()) * 1.0 * 1000);
							
							spawnDecal(attacker.torsoType.decal, player.character.position.x, player.character.position.y - 10);
							Game.map.audio.play(attacker.torsoType.audio, true);
						}
					}
				}
				if (lastAttacker != null) {
					distance = PointMath.distanceBetweenPoints(attacker.position, lastAttacker.position);
					if (distance < 20) {
						attacker.movementDelayedTime = Math.round(time + (0.5 + Math.random()) * 1 * 1000);
					}
				}
				lastAttacker = attacker;
			}
		}
		
		if (player.playerAttacked && player.character.attacking) {
			player.character.attacking = false;
		}
	}
	
	public function spawnDecal(asset:String, x:Float, y:Float):Void {
		var decal:Bitmap = new Bitmap(Assets.getBitmapData(asset));
		decal.x = x - decal.width / 2;
		decal.y = y - decal.height / 2;
		
		Actuate.tween(decal, 0.5, { alpha: 0.0 } ).autoVisible(true).onComplete(removeDecal, [decal]).delay(0.1).ease(Quad.easeInOut);
		Game.map.artwork.addChild(decal);
	}
	
	function removeDecal(decal:Bitmap):Void {
		Game.map.artwork.removeChild(decal);
	}
	
}