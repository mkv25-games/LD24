package level;
import character.Character;
import character.CharacterType;
import core.Game;
import nme.display.Sprite;
import nme.events.MouseEvent;
import nme.Lib;
import level.LevelTitle;

/**
 * ...
 * @author Markavian
 */

class LevelModel 
{
	var hud:LevelHUD;
	
	var attackers:List<Character>;
	var recycler:List<Character>;
	var spawnPoints:Array<Dynamic>;
	
	var lastSpawnTime:Int;
	var paused:Bool;
	
	var titleLoaded:Bool;
	var titleLoading:Bool;
	var arenaLoaded:Bool;
	var arenaLoading:Bool;
	var fightBegun:Bool;
	var fightBeginning:Bool;
	var evolving:Bool;
	var evolved:Bool;
	var dying:Bool;
	var dead:Bool;
	
	var levels:Array<Array<CharacterType>>;
	
	public var score:Float;
	public var combos:Float;
	
	public function new(hud:LevelHUD) 
	{
		this.hud = hud;
		
		attackers = new List<Character>();
		recycler = new List<Character>();
		spawnPoints = [
			{x:-234, y:-96}, 
			{x:4, y:-173}, 
			{x:230, y:-109}, 
			{x:220, y:35}, 
			{x:-6, y:99}, 
			{x: -229, y:35 }
		];
		
		lastSpawnTime = Lib.getTimer();
		paused = true;
		
		titleLoaded = false;
		titleLoading = false;
		arenaLoaded = false;
		arenaLoading = false;
		fightBegun = false;
		fightBeginning = false;
		evolving = false;
		evolved = false;
		dying = false;
		dead = false;
		
		score = 0;
		combos = 0;
		
		levels = new Array<Array<CharacterType>>();
		levels.push([CharacterType.KITTEH, CharacterType.HUMAN, CharacterType.HUMAN]);
		levels.push([CharacterType.KITTEH, CharacterType.HUMAN, CharacterType.GHOST]);
		levels.push([CharacterType.KITTEH, CharacterType.HUMAN, CharacterType.GHOST]);
		levels.push([CharacterType.KITTEH, CharacterType.GHOST, CharacterType.GHOST, CharacterType.HUMAN]);
		levels.push([CharacterType.HUMAN, CharacterType.GHOST, CharacterType.GHOST, CharacterType.VAMPIRE]);
		levels.push([CharacterType.WEREWOLF, CharacterType.GHOST, CharacterType.GHOST, CharacterType.VAMPIRE]);
		levels.push([CharacterType.WEREWOLF, CharacterType.WEREWOLF, CharacterType.GHOST, CharacterType.VAMPIRE]);
		levels.push([CharacterType.WEREWOLF, CharacterType.WEREWOLF, CharacterType.GHOST, CharacterType.VAMPIRE, CharacterType.VAMPIRE, CharacterType.HUMAN]);
		levels.push([CharacterType.WEREWOLF, CharacterType.TENTACRUEL, CharacterType.GHOST, CharacterType.WEREWOLF, CharacterType.VAMPIRE, CharacterType.VAMPIRE, CharacterType.HUMAN]);
		levels.push([CharacterType.TENTACRUEL, CharacterType.TENTACRUEL, CharacterType.WEREWOLF, CharacterType.WEREWOLF, CharacterType.VAMPIRE, CharacterType.VAMPIRE, CharacterType.HUMAN]);
		levels.push([CharacterType.TENTACRUEL, CharacterType.TENTACRUEL, CharacterType.WEREWOLF, CharacterType.WEREWOLF, CharacterType.VAMPIRE, CharacterType.VAMPIRE, CharacterType.HUMAN, CharacterType.KITTEH]);
		levels.push([CharacterType.TENTACRUEL, CharacterType.TENTACRUEL, CharacterType.WEREWOLF, CharacterType.WEREWOLF, CharacterType.VAMPIRE, CharacterType.VAMPIRE, CharacterType.HUMAN, CharacterType.GHOST]);
	}
	
	public function considerOptions():Void {
		var game:Game = Game.map;
		
		if (titleLoaded == false) {
			if (titleLoading == false) {
				titleLoad();
			}
		}
		
		if (paused) {
			return;
		}
		
		game.characters.model.moveAll();
		game.characters.model.attackAll();
		
		clearAttackers();
		spawnAttackers();
		
		if (game.player.character.health <= 0) {
			death();
		}
	}
	
	function titleLoad():Void {
		titleLoading = true;
		titleLoaded = false;
		arenaLoaded = false;
		paused = true;
		
		score = 0;
		combos = 0;
		
		hud.mainTitle.animateInOnly(titleLoadComplete);
	}
	
	function titleLoadComplete():Void {
		titleLoading = false;
		titleLoaded = true;
		
		// wait for mouse click
	}
	
	function arenaLoad():Void {
		arenaLoaded = false;
		arenaLoading = true;
		paused = true;
		
		Game.map.player.reset();
		Game.map.characters.reset();
		while (attackers.length > 0) {
			attackers.pop();
		}
		Game.map.characters.model.characters.push(Game.map.player.character);
		
		Game.map.evolution.animateEvolutionIn();
		
		hud.mainTitle.animateOutOnly();
		hud.arenaLoadTitle.animateIn(arenaLoadComplete);
	}
	
	function arenaLoadComplete():Void {
		arenaLoaded = true;
		arenaLoading = false;
		
		startFight();
	}
	
	function startFight():Void {
		var game:Game = Game.map;
		
		fightBeginning = true;
		fightBegun = false;
		hud.fightTitle.animateIn(startFightComplete);
	}
	
	function startFightComplete():Void {
		fightBeginning = false;
		fightBegun = true;
		paused = false;
	}
	
	function evolve():Void {
		paused = true;
		evolving = true;
		evolved = false;
		
		Game.map.evolution.evolvePlayer();
		
		hud.evolvingTitle.animateIn(evolveComplete);
	}
	
	function evolveComplete():Void {
		evolving = false;
		evolved = true;
		
		Game.map.evolution.clearEvolution();
		Game.map.player.level += 1;
		
		startFight();
	}
	
	function death():Void {
		dying = true;
		dead = false;
		paused = true;
		
		hud.deathTitle.animateIn(deathComplete);
	}
	
	function deathComplete():Void {
		dying = false;
		dead = true;
		
		titleLoad();
	}
	
	public function goHereAndKillShit(e:MouseEvent):Void {
		var player = Game.map.player;
		if (arenaLoaded == false && titleLoaded && arenaLoading == false) {
			titleLoadComplete();
			arenaLoad();
		}
		else if (arenaLoaded && !paused && !evolving) {
			player.character.attacking = true;
			player.goTo(e.localX, e.localY);
		}
	}
	
	inline function clearAttackers():Void {
		while (attackers.length > 0) {
			var attacker = attackers.pop();
			if (attacker.health <= 0) {
				if (!attacker.dying) {
					attacker.dying = true;
				}
				if (attacker.dying) {
					attacker.scale = Math.max(attacker.scale - 0.1, 0);
					if (attacker.scale == 0) {
						attacker.dead = true;
					}
					else {
						recycler.push(attacker);
					}
				}
				if(attacker.dead) {
					Game.map.characters.model.characters.remove(attacker);
					score += Game.map.player.level * 10;
					Game.map.player.kills += 1;
					collectEvolution(attacker);
				}
			}
			else {
				recycler.push(attacker);
			}
		}
		
		while (recycler.length > 0) {
			attackers.push(recycler.pop());
		}
	}
	
	inline function spawnAttackers():Void {
		var attackerTypes = [CharacterType.HUMAN, CharacterType.KITTEH, CharacterType.WEREWOLF, CharacterType.VAMPIRE, CharacterType.GHOST, CharacterType.TENTACRUEL];
		var player = Game.map.player;
		
		if (attackers.length < 6) {
			var now:Int = Lib.getTimer();
			
			if(now > lastSpawnTime + 1000) {
				var attacker = new Character();
				
				if (player.level < 12) {
					attackerTypes = levels[player.level];
					attacker.setGenome(attackerTypes[(player.kills) % attackerTypes.length]);
				}
				else {
					if (Math.random() < 0.2) {
						attacker.mergeGenomes(attackerTypes[(player.kills) % attackerTypes.length], attackerTypes[(attackers.length + 1) % attackerTypes.length]);
					}
					else {
						attacker.setGenome(attackerTypes[(player.kills) % attackerTypes.length]);
					}
				}
				
				// Pick a spawning gate to enter from
				var spawnPoint = spawnPoints[Math.round(Math.random() * 1000) % spawnPoints.length];
				
				attacker.position.x = spawnPoint.x;
				attacker.position.y = spawnPoint.y;
				attacker.speed = 1.0;
				attacker.spawnTime = Lib.getTimer();
				attacker.justSpawned = true;
				
				attackers.push(attacker);
				
				Game.map.characters.model.characters.add(attacker);
				Game.map.audio.play(attacker.headType.audio);
				
				lastSpawnTime = now;
			}
		}
	}
	
	inline function collectEvolution(creature:Character):Void {
		Game.map.evolution.storeEvolution(creature);
		
		if (Game.map.evolution.evolutionFilled) {
			evolve();
		}
	}
}