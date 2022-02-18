package;
import flixel.*;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * ...
 * Recrate by Me
 */
class TrollEnding extends FlxState
{

	var _lolEnding:Bool = false;
	

	public function new(lolEnding:Bool = true) 
	{
		super();
		_lolEnding = lolEnding;
		
	}
	
	override function create() 
	{
		super.create();
		
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image("final/Troll Ending"));
		add(bg);
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (FlxG.keys.pressed.ENTER){
			endIt();
		}
		
	}
	
	
	public function endIt(e:FlxTimer=null){
		trace("ENDING");
		FlxG.switchState(new StoryMenuState());
	}
	
}
