package;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import MusicBeatState;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;
	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];
	var swagDialogue:FlxTypeText;
	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;
	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	var pixel = PlayState.isPixelArrows;
	var builtDifferent = PlayState.SONG.song.toLowerCase() == "senpai" || PlayState.SONG.song.toLowerCase() == "roses" || PlayState.SONG.song.toLowerCase() == "thorns";

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

		box = new FlxSprite(0, 0);
		
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
			default:
				hasDialog = PlayState.songHasDialogue;
				box.frames = Paths.getSparrowAtlas('UI/speech_bubble_talking');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open0', 24, false);
				box.animation.addByPrefix('normal', 'speech bubble normal0', 24, true);
				box.animation.addByPrefix('angry', 'AHH speech bubble0', 24, true);
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		portraitLeft = new FlxSprite(-20, 40);
		
		if (builtDifferent)
		{
			portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
			portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
			portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
		}
		else 
		{
			portraitLeft.loadGraphic(Paths.image("dialoguePortraits/" + PlayState.dad.curCharacter));
			portraitLeft.setPosition(166, 204);
			portraitLeft.antialiasing = true;
		}

		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitRight = new FlxSprite(0, 40);

		if (builtDifferent)
		{
			portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
			portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
			portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
		}
		else 
		{
			portraitRight.loadGraphic(Paths.image("dialoguePortraits/" + PlayState.boyfriend.curCharacter));
			portraitRight.setPosition(760, 204);
			portraitRight.antialiasing = true;
		}
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;
		
		box.animation.play('normalOpen');
		trace("pixel? " + pixel);

		if (pixel)
		{
			box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
			box.updateHitbox();
			box.setPosition(-32, 45);
		}
		else 
		{
			box.setPosition(50, 380);
		}
		
		add(box);

		if (builtDifferent)
			portraitLeft.screenCenter(X);

		if (pixel)
		{
			handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('UI/hand_textbox_pixel'));
			handSelect.setGraphicSize(Std.int(handSelect.width * PlayState.daPixelZoom * 0.9));
		}else 
		{
			handSelect = new FlxSprite(FlxG.width * 0.84, FlxG.height * 0.79).loadGraphic(Paths.image('UI/hand_textbox'));
			handSelect.scale.set(0.7, 0.7);
			handSelect.antialiasing = true;
		}
		add(handSelect);

		if (pixel)
		{
			dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
			swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		}
		else 
		{
			dropText = new FlxText(162, 502, Std.int(FlxG.width * 0.8), "", 32);
			swagDialogue = new FlxTypeText(160, 500, Std.int(FlxG.width * 0.8), "", 32);
		}

		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD89494;

		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];

		if (pixel)
		{
			add(dropText);
			add(swagDialogue);
		}
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
			portraitLeft.visible = false;
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

		if (box.animation.curAnim.name == "normal")
			box.setPosition(50, 380);
		else if (box.animation.curAnim.name == "angry")
			box.setPosition(15, 310);

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.anyJustPressed([SPACE, ENTER]) && dialogueStarted == true)
		{
			if (!pixel)
			{
				remove(dialogue);
				FlxG.sound.play(Paths.sound('dialogueClose'), 0.8);
			}
			else 
			{
				FlxG.sound.play(Paths.sound('clickText'), 0.8);
			}
			
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
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						handSelect.alpha -= 1 / 5;
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
				if (!pixel)
				{
					if (dialogue.finishedText)
					{
						dialogueList.remove(dialogueList[0]);
						startDialogue();
					}else 
					{
						dialogue.killTheTimer();
						dialogue.kill();
						remove(dialogue);
						dialogue.destroy();

						dialogue = new Alphabet(45, 450, dialogueList[0], false, true, 0.0, 0.7);
						add(dialogue);
					}
				}
				else 
				{
					dialogueList.remove(dialogueList[0]);
					startDialogue();
				}
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();

		if (pixel)
		{
			swagDialogue.resetText(dialogueList[0]);
			swagDialogue.start(0.04, true);
		}else 
		{
			dialogue = new Alphabet(45, 450, dialogueList[0], false, true, 0.04, 0.7);
			add(dialogue);
		}

		switch (curCharacter)
		{
			case 'dad':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'bf':
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		if (splitName[0] == "")
		{
			box.animation.play("normal");
			dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
		}
		else if (splitName[0] == "angry")
		{
			box.animation.play("angry");
			dialogueList[0] = dialogueList[0].substr(splitName[1].length + 7).trim();
		}
	}
}
