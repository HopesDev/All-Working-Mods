package;
import flixel.*;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * ...
 * Recrate by Me
 */
class BadEnding extends FlxState
{

	var _badEnding:Bool = false;
	

	public function new(badEnding:Bool = true) 
	{
		super();
		_badEnding = badEnding;
		
	}
	
	override function create() 
	{
		super.create();
		
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image("final/Good Ending"));
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
