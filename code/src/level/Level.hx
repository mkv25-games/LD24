package level;

/**
 * ...
 * @author Markavian
 */

class Level 
{
	public var hud:LevelHUD;
	public var model:LevelModel;
	
	public function new() 
	{
		hud = new LevelHUD();
		model = new LevelModel(hud);
	}
	
}