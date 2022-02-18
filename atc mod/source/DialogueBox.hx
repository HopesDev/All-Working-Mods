package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var bgA1:FlxSprite;
	var bgA2:FlxSprite;
	var bgA3:FlxSprite;
	var bgA4:FlxSprite;


	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);

		    case '24':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('Cuts/box');
				box.animation.addByPrefix('normalOpen', 'Símbolo 1', 24, false);
				box.animation.addByIndices('normal', 'Símbolo 1', [11], "", 24);
		}

		this.dialogueList = dialogueList;
		
		this.dialogueList = dialogueList;

		bgA1 = new FlxSprite(-645,-345);
		bgA1.scale.set(0.5,0.5); 
		bgA1.antialiasing = true;		
		bgA1.visible = true;
		add(bgA1);

		bgA2 = new FlxSprite(-650,-350);
		bgA2.scale.set(0.5,0.5); 
		bgA2.antialiasing = true;		// this line probably isn't necessary though...
		bgA2.visible = true;
		add(bgA2);

		bgA3 = new FlxSprite(-650,-350);
		bgA3.scale.set(0.5,0.5); 		// this line probably isn't necessary though...
		bgA3.visible = true;
		add(bgA3);

		bgA4 = new FlxSprite(-650,-350);
		bgA4.scale.set(0.5,0.5); 		// this line probably isn't necessary though...
		bgA4.visible = true;
		add(bgA4);


				

		
		portraitLeft = new FlxSprite(15, 75);
		portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
		portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
	    portraitLeft.updateHitbox();
	    portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitLeft = new FlxSprite(-380, 100);
		portraitLeft.frames = Paths.getSparrowAtlas('portraits/mortemPortrait');
		portraitLeft.animation.addByPrefix('enter', 'Mortem Portrait Enter', 24, false);
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * -0.15));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;
		
		box.animation.play('normalOpen');
		box.updateHitbox();
		add(box);

		box.screenCenter(X);

		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
		add(handSelect);


		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 36);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 36);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

				if (curCharacter == 'BG' && dialogueStarted == true)
		{
			dialogueList.remove(dialogueList[0]);
			startDialogue();
		}

				if (curCharacter == 'BG2' && dialogueStarted == true)
		{
			dialogueList.remove(dialogueList[0]);
			startDialogue();
		}
		        if (curCharacter == 'BG3' && dialogueStarted == true)
		{
			dialogueList.remove(dialogueList[0]);
			startDialogue();
		}
	        	if (curCharacter == 'BG4' && dialogueStarted == true)
		{
			dialogueList.remove(dialogueList[0]);
			startDialogue();
		}
	         	if (curCharacter == 'BG5' && dialogueStarted == true)
		{
			dialogueList.remove(dialogueList[0]);
			startDialogue();
		}
		        if (curCharacter == 'BG6' && dialogueStarted == true)
		{
			dialogueList.remove(dialogueList[0]);
			startDialogue();
		}
		        if (curCharacter == 'BGS1' && dialogueStarted == true)
		{
			dialogueList.remove(dialogueList[0]);
			startDialogue();
		}
		        if (curCharacter == 'BGS2' && dialogueStarted == true)
		{
			dialogueList.remove(dialogueList[0]);
			startDialogue();
		}


		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgA1.alpha -= 1 / 5;
						bgA2.alpha -= 1 / 5;
						bgA3.alpha -= 1 / 5;
						bgA4.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		
		// bgA1 = loadGraphic(Paths.image('maginage/Cuts/$curBg'));

		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			case 'dad':
				portraitRight.visible = false;
				if (!portraitLeft.visible) {
				    portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
					box.flipX = true;
				}

				case 'BG':			
				remove(bgA1);
				bgA1.loadGraphic(Paths.image('Cut/A1'));
				add(bgA1);

				case 'BG2':		
					remove(bgA1);
					bgA2.loadGraphic(Paths.image('Cuts/A2'));
					add(bgA2);
				
				case 'BG3':
					remove(bgA1);		
					remove(bgA2);
					bgA3.loadGraphic(Paths.image('Cuts/A3'));
					add(bgA3);

				case 'BG4':
					remove(bgA1);		
					remove(bgA2);
					remove(bgA3);
					bgA4.loadGraphic(Paths.image('Cuts/A4'));
					add(bgA4);

				case 'BG6':
					remove(bgA1);		
					remove(bgA2);
					remove(bgA3);
					remove(bgA4);

		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
