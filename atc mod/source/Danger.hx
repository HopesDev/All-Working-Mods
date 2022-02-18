package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class Danger extends MusicBeatState
{

    var txtWeekTitle:FlxText;
    var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
    var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
    var grpWeekText:FlxTypedGroup<MenuItem>;
    var curDifficulty:Int = 1;
var sacrife:FlxText;

var scoreText:FlxText;

	var weekData:Array<Dynamic> = [
		['6am'],

	];

	public static var weekUnlocked:Array<Bool> = [true, true, true, true, true, true, true];

	var weekCharacters:Array<Dynamic> = [
		['', 'bf', 'gf'],

	];

	var weekNames:Array<String> = [
		"",

	];


    var curWeek:Int = 0;

    override function create()
    {
    var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    add(bg);

    sacrife = new FlxText( 0, "Are you sure you want to continue? There is no way back", 20);
    sacrife.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
    sacrife.scrollFactor.set();
    {
        add(sacrife);
    }

    var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');

    leftArrow = new FlxSprite(grpWeekText.members[0].x + grpWeekText.members[0].width + 10, grpWeekText.members[0].y + 10);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
        leftArrow.screenCenter();
		leftArrow.y += 170;
		leftArrow.x -= 240;
		difficultySelectors.add(leftArrow);

		sprDifficulty = new FlxSprite(leftArrow.x + 130, leftArrow.y);
		sprDifficulty.frames = ui_tex;
		sprDifficulty.animation.addByPrefix('easy', 'EASY');
		sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
		sprDifficulty.animation.addByPrefix('hard', 'HARD');
		sprDifficulty.animation.play('easy');
        sprDifficulty.x = 64;
		sprDifficulty.y = 110;
		changeDifficulty();

		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(sprDifficulty.x + sprDifficulty.width + 50, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
        rightArrow.screenCenter();
		rightArrow.y += 170;
		rightArrow.x += 260;
		difficultySelectors.add(rightArrow);

		trace("Line 165");

		super.create();
	}

	override function update(elapsed:Float)
	{
            
            if (FlxG.keys.justPressed.F)
            {
            FlxG.fullscreen = !FlxG.fullscreen;
            }
    
            if (FlxG.sound.music.volume < 0.7)
            {
                FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
            }
    
            var upP = controls.UP_P;
            var downP = controls.DOWN_P;
            var accepted = controls.ACCEPT;
    
            if (controls.RIGHT_P)
            {
                changeDifficulty(-1);
            }
            if (controls.LEFT_P)
            {
                changeDifficulty(1);
            }
            
    
            if (controls.BACK)
            {
                FlxG.sound.music.stop();
                FlxG.autoPause = true;
                FlxG.switchState(new MainMenuState());
            }

         if (controls.ACCEPT)
        {
          bobweek();
        }
    }

    
	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;
    
         function bobweek()
         {
            if (weekUnlocked[curWeek])
                {
                    if (stopspamming == false)
                    {
                        FlxG.sound.play(Paths.sound('confirmMenu'));
                        stopspamming = true;
                    }

            var diffic = "";

			switch (curDifficulty)
			{
				case 0:
					diffic = '-easy';
				case 2:
					diffic = '-hard';
			}

            PlayState.storyDifficulty = curDifficulty;

			PlayState.SONG = Song.loadFromJson(StringTools.replace(PlayState.storyPlaylist[0]," ", "-").toLowerCase() + diffic, StringTools.replace(PlayState.storyPlaylist[0]," ", "-").toLowerCase());
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{

        
                FlxG.switchState(new VideoState("assets/videos/final/combat.webm", new PlayState()));

                LoadingState.loadAndSwitchState(new PlayState(), true);
                
            });

        }
    }
	
    function changeDifficulty(change:Int = 0):Void
        {
            curDifficulty += change;
    
            if (curDifficulty < 0)
                curDifficulty = 2;
            if (curDifficulty > 2)
                curDifficulty = 0;
    
            sprDifficulty.offset.x = 0;
    
            switch (curDifficulty)
            {
                case 0:
                    sprDifficulty.animation.play('easy');
                    sprDifficulty.offset.x = 20;
                case 1:
                    sprDifficulty.animation.play('normal');
                    sprDifficulty.offset.x = 70;
                case 2:
                    sprDifficulty.animation.play('hard');
                    sprDifficulty.offset.x = 20;
            }
    
            sprDifficulty.alpha = 0;

            sprDifficulty.y = leftArrow.y - 15;

            FlxG.sound.play(Paths.sound('scrollMenu'));
        }
    }
