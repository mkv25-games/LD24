package core;
import nme.Assets;
import nme.Lib;
import nme.media.Sound;
import nme.media.SoundChannel;
import nme.media.SoundTransform;

/**
 * ...
 * @author Markavian
 */

class Audio 
{
	var sounds:Hash<Sound>;
	var channels:Hash<SoundChannel>;
	var timers:Hash<Int>;
	
	public function new() 
	{
		sounds = new Hash<Sound>();
		channels = new Hash<SoundChannel>();
		timers = new Hash<Int>();
	}
	
	public function loop(asset:String, volume:Float=0.5):Void {
		var sound = Assets.getSound(asset);
		var transform = new SoundTransform(volume);
		var channel = sound.play(0,9999, transform);
	}
	
	public function play(asset:String, randomVolume:Bool=false):Void {
		var sound = Assets.getSound(asset);
		var now = Lib.getTimer();	
		
		var volume = 1.0;
		if (randomVolume) {
			volume = 0.2 + Math.random() * 0.4;
		}
		
		var playSound:Bool = false;
		if (sounds.exists(asset)) {
			if (timers.get(asset) < now - (100 + Math.round(Math.random() * 100))) {
				playSound = true;
			}
		}
		else {
			playSound = true;
		}
		
		if (playSound) {
			var transform = new SoundTransform(volume);
			var channel = sound.play(0, 0, transform);
			sounds.set(asset, sound);
			channels.set(asset, channel);
			timers.set(asset, now);
		}
		
	}
	
	
	
}