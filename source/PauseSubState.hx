package;

import flixel.graphics.frames.FlxAtlasFrames;
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = [];
	var menuItemsOG:Array<String> = ['Resume', "Change Difficulty", "Practice mode", "Botplay", 'Restart Song', 'Exit to menu'];
	var curSelected:Int = 0;

	var difficultyChoices = [];

	var pauseMusic:FlxSound;
	var practiceText:FlxText;
	var botText:FlxText;

	public function new(x:Float, y:Float)
	{
		super();
		menuItems = menuItemsOG;

		for (i in 0...CoolUtil.difficultyStuff.length) {
			var diff:String = '' + CoolUtil.difficultyStuff[i][0];
			difficultyChoices.push(diff);
		}
		difficultyChoices.push('BACK');

		pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite;

		if (CoolThings.secretShh)
		{
			bg = new FlxSprite(400, 170);
			bg.frames = Paths.getSparrowAtlas('rick');
			bg.animation.addByPrefix('lol', 'Simbolo 1', 60, true);
			bg.animation.play('lol');
			bg.scale.set(3,2);
			bg.alpha = 0.4;
			//bg.scrollFactor.set(0.6, 0.6);
			bg.antialiasing = FlxG.save.data.antialiasing;
			add(bg);	
		}else 
		{
			bg = new FlxSprite();
			bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
			bg.alpha = 0;
			bg.scrollFactor.set();
			add(bg);
		}

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += PlayState.SONG.song;
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
		levelDifficulty.text += CoolUtil.difficultyString();
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		practiceText = new FlxText(20, 15 + 69, 0, "PRACTICE MODE", 32);
		practiceText.scrollFactor.set();
		practiceText.setFormat(Paths.font("vcr.ttf"), 32);
		practiceText.updateHitbox();
		add(practiceText);

		botText = new FlxText(20, 15 + 100, 0, "BOTPLAY", 32);
		botText.scrollFactor.set();
		botText.setFormat(Paths.font("vcr.ttf"), 32);
		botText.updateHitbox();
		add(botText);

		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;
		practiceText.alpha = 0;
		botText.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);
		practiceText.x = FlxG.width - (practiceText.width + 20);
		botText.x = FlxG.width - (botText.width + 20);

		FlxTween.tween(bg, {alpha: 0.4}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		if (FlxG.save.data.practice)
		{
			practiceText.alpha = 1;
		}
		else
		{
			practiceText.alpha = 0;
		}

		if (CoolThings.botplay)
		{
			botText.alpha = 1;
		}
		else
		{
			botText.alpha = 0;
		}

		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];
			for (i in 0...difficultyChoices.length-1) {
				if(difficultyChoices[i] == daSelected) {
					var name:String = PlayState.SONG.song.toLowerCase();
					var poop = Highscore.formatSong(name, curSelected);
					PlayState.SONG = Song.loadFromJson(poop, name);
					PlayState.storyDifficulty = curSelected;
					FlxG.resetState();
					FlxG.sound.music.volume = 0;
					//PlayState.changedDifficulty = true;
					//PlayState.cpuControlled = false;
					return;
				}
			} 

			switch (daSelected)
			{
				case "Resume":
					close();
				case 'Change Difficulty':
					menuItems = difficultyChoices;
					regenMenu();
				case "Practice mode":
					FlxG.save.data.practice = !FlxG.save.data.practice;
					trace("practice : " + FlxG.save.data.practice);
				case "Botplay": 
					CoolThings.botplay = !CoolThings.botplay;
					FlxG.save.data.botplay = !FlxG.save.data.botplay;
					trace("botplay : " + CoolThings.botplay);
				case "Downscroll": 
					CoolThings.downscroll = !CoolThings.downscroll;
					trace("downscroll : " + CoolThings.downscroll);
				case "Restart Song":
					FlxG.resetState();
				case "Exit to menu":
				{
					if (PlayState.isStoryMenu)
						FlxG.switchState(new StoryMenuState());
					else if (PlayState.isFreeplayMenu)
						FlxG.switchState(new FreeplayState());
					else 
						FlxG.switchState(new MainMenuState());
				}
				case 'BACK':
					menuItems = menuItemsOG;
					regenMenu();
			}
		}

		if (FlxG.keys.justPressed.J)
		{
			// for reference later!
			// PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxKey.J, null);
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}

	function regenMenu():Void {
	for (i in 0...grpMenuShit.members.length) {
		this.grpMenuShit.remove(this.grpMenuShit.members[0], true);
	}
	for (i in 0...menuItems.length) {
		var item = new Alphabet(0, 70 * i + 30, menuItems[i], true, false);
		item.isMenuItem = true;
		item.targetY = i;
		grpMenuShit.add(item);
	}
	curSelected = 0;
	changeSelection();
	}
}
