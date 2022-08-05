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
	var menuItemsOG:Array<String> = ['Resume', "Change Difficulty", "more options", 'Restart Song', 'Exit to menu'];
	var curSelected:Int = 0;

	var difficultyChoices = [];

	var pauseMusic:FlxSound;
	var txt1:FlxText;
	var txt2:FlxText;
	var txt3:FlxText;

	public function new(x:Float, y:Float)
	{
		super();
		menuItems = menuItemsOG;

		for (i in 0...CoolUtil.difficultyStuff.length) {
			var diff:String = '' + CoolUtil.difficultyStuff[i][0];
			difficultyChoices.push(diff);
		}
		difficultyChoices.insert(0, 'BACK');

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

		txt1 = new FlxText(20, 510 + 100, 0, "BOTPLAY", 32);
		txt1.scrollFactor.set();
		txt1.setFormat(Paths.font("vcr.ttf"), 32);
		txt1.updateHitbox();
		add(txt1);

		txt2 = new FlxText(20, 510 + 131, 0, "PRACTICE MODE", 32);
		txt2.scrollFactor.set();
		txt2.setFormat(Paths.font("vcr.ttf"), 32);
		txt2.updateHitbox();
		add(txt2);

		txt3 = new FlxText(20, 510 + 162, 0, "HITSOUNDS", 32);
		txt3.scrollFactor.set();
		txt3.setFormat(Paths.font("vcr.ttf"), 32);
		txt3.updateHitbox();
		add(txt3);

		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);
		txt1.x = FlxG.width - (txt1.width + 20);
		txt2.x = FlxG.width - (txt2.width + 20);
		txt3.x = FlxG.width - (txt3.width + 20);
		
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
		txt1.visible = CoolThings.botplay;
		txt2.visible = PlayState.practiceMode;
		txt3.visible = CoolThings.hitsounds;

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

		if (controls.BACK)
		{
			if (menuItems != menuItemsOG)
			{
				menuItems = menuItemsOG;
				regenMenu();
			}
		}

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];
			for (i in 1...difficultyChoices.length) 
			{
				if(difficultyChoices[i] == daSelected) 
				{
					var name:String = PlayState.SONG.song.toLowerCase();
					var poop = Highscore.formatSong(name, curSelected - 1);
					PlayState.SONG = Song.loadFromJson(poop, name);
					PlayState.storyDifficulty = curSelected - 1;
					FlxG.resetState();
					FlxG.sound.music.volume = 0;
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
				case "more options": 
					menuItems = ["BACK", "Botplay", "Practice mode", "hitsounds"];
					regenMenu();
				case "Practice mode":
					PlayState.practiceMode = !PlayState.practiceMode;
					trace("practice : " + PlayState.practiceMode);
				case "Botplay": 
					CoolThings.botplay = !CoolThings.botplay;
					trace("botplay : " + CoolThings.botplay);
				case "hitsounds": 
					CoolThings.hitsounds = !CoolThings.hitsounds;
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

	function regenMenu():Void 
	{
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
