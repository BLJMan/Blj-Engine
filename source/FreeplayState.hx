package;

import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.system.FlxSound;
import lime.utils.Assets;

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	private var mainColor = FlxColor.WHITE;

	var stupidShit:String = "-------extra-songs";

	var vocals:FlxSound;
	var inst:FlxSound;

	var scoreBG:FlxSprite;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var grpIcons:FlxTypedGroup<HealthIcon>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	var bg:FlxSprite;

	var leText:String;
	var text:FlxText;
	var textBG:FlxSprite;

	var iRestarted = FlxG.save.data.restarted;

	override function create()
	{
		/*var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));

		for (i in 0...initSonglist.length)
		{
			songs.push(new SongMetadata("Tutorial", 1, 'gf', FlxColor.PINK));
			//songs.push(new SongMetadata("eggnog", 5, 'parents-christmas', FlxColor.fromRGB(141, 165, 206)));
			
		}*/

		songs.push(new SongMetadata("Tutorial", 1, 'gf', FlxColor.PINK));

		if (PlayState.freeplayShit)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		if (!iRestarted)
		{
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		}

		

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		if (StoryMenuState.weekUnlocked[2] || isDebug)
			addWeek(['Bopeebo', 'Fresh', 'Dadbattle'], 1, ['dad'], [FlxColor.fromRGB(129, 100, 223)]);

		if (StoryMenuState.weekUnlocked[2] || isDebug)
			addWeek(['Spookeez', 'South', 'Monster'], 2, ['spooky', "spooky", "monster"], [FlxColor.fromRGB(30, 45, 60)]);

		if (StoryMenuState.weekUnlocked[3] || isDebug)
			addWeek(['Pico', 'Philly', 'Blammed'], 3, ['pico'], [FlxColor.fromRGB(111, 19, 60)]);

		if (StoryMenuState.weekUnlocked[4] || isDebug)
			addWeek(['Satin-Panties', 'High', 'Milf'], 4, ['mom'], [FlxColor.fromRGB(203, 113, 170)]);

		if (StoryMenuState.weekUnlocked[5] || isDebug)
			addWeek(['Cocoa', 'Eggnog', 'Winter-Horrorland'], 5, ['parents-christmas', 'parents-christmas', 'monster-christmas'], [FlxColor.fromRGB(141, 165, 206)]);

		if (StoryMenuState.weekUnlocked[6] || isDebug)
			addWeek(['Senpai', 'Roses', 'Thorns'], 6, ['senpai', 'senpai', 'spirit'], [FlxColor.fromRGB(206, 106, 169)]);

		if (StoryMenuState.weekUnlocked[7] || isDebug)
			addWeek(['Ugh', 'Guns', 'Stress'], 7, ['tankman', 'tankman', 'tankman'], [FlxColor.fromRGB(30, 45, 60)]);

		// LOAD MUSIC

		// LOAD CHARACTERS

		songs.push(new SongMetadata("extra-songs", 1, "gf", FlxColor.GRAY));

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing  = CoolThings.antialiasing;
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		grpIcons = new FlxTypedGroup<HealthIcon>();
		add(grpIcons);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			grpIcons.add(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}
		
		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		for (i in 0...songs.length)
		{
			if (songs[i].songName.toLowerCase() == "extra-songs")
				iconArray[i].visible = false;
		}

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(1, 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		textBG = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);
		leText = "Press SPACE to listen to the selected Song";
		text = new FlxText(textBG.x - 500, textBG.y + 4, FlxG.width, leText, 18);
		text.setFormat(Paths.font("funkin.otf"), 18, FlxColor.WHITE, RIGHT);
		text.antialiasing = CoolThings.antialiasing;
		text.scrollFactor.set();
		add(text);

		super.create();
	}

	function regenMenu():Void 
	{
		songs = [];

		canAccept = false;
		new FlxTimer().start(0.3, function(timr:FlxTimer)
		{
			canAccept = true;
		}, 1);

		for (i in 0...iconArray.length)
		{
			iconArray[i].visible = false;
		}

		for (i in 0...grpSongs.members.length) 
		{
			this.grpSongs.remove(this.grpSongs.members[0], true);
		}

		var initSonglist = CoolUtil.coolTextFile(Paths.txt('extraSonglist'));

		for (i in 0...initSonglist.length)
		{
			songs.push(new SongMetadata(initSonglist[i], 1, 'gf', FlxColor.PINK));
			
		}

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);
		}
		curSelected = 0;
		changeSelection();
	}

	var canAccept:Bool = true;

	public function addSong(songName:String, weekNum:Int, songCharacter:String, songColor:FlxColor)
	{

		songs.push(new SongMetadata(songName, weekNum, songCharacter, songColor));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>, ?songColor:Array<FlxColor>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];
		if (songColor == null)
			songColor = [FlxColor.WHITE];

		var num:Array<Int> = [0, 0];
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num[0]], songColor[num[0]]);

			if (songCharacters.length != 1)
				num[0]++;
			if (songColor.length != 1)
				num[0]++;
		}
	}

	function playCurSelected()
	{
		iRestarted = true;

		#if PRELOAD_ALL
		
		#end
		FlxG.sound.music.stop();
		//FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0.5);
		vocals = new FlxSound().loadEmbedded(Paths.voices(songs[curSelected].songName));
		inst = new FlxSound().loadEmbedded(Paths.inst(songs[curSelected].songName));
		vocals.play();
		inst.play();
		//Conductor.songPosition = inst.time
		//vocals.time = Conductor.songPosition;
		leText = "Press SPACE to listen to the selected Song" + " - NOW PLAYING: " + songs[curSelected].songName;
		text.text = leText;
		text.x = textBG.x - 400;
		FlxG.sound.list.add(vocals);
		FlxG.sound.list.add(inst);
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.G)
		{
			resyncVocals();
		}

		if (FlxG.keys.justPressed.SPACE && songs[curSelected].songName.toLowerCase() != stupidShit)
		{
			if (vocals != null && inst != null)
			{
				vocals.stop();
				inst.stop();
			}
			playCurSelected();
		}

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		super.update(elapsed);

		switch (songs[curSelected].songName.toLowerCase())
		{
			case 'tutorial':
				FlxTween.color(bg, 0.35, bg.color, FlxColor.PINK);
			case 'bopeebo' | 'fresh' | 'dadbattle': 
				FlxTween.color(bg, 0.35, bg.color, FlxColor.fromRGB(129, 100, 223));
			case 'spookeez' | 'south' | 'monster' : 
				FlxTween.color(bg, 0.35, bg.color, FlxColor.fromRGB(30, 45, 60));
			case 'pico' | 'philly' | 'blammed': 
				FlxTween.color(bg, 0.35, bg.color, FlxColor.fromRGB(111, 19, 60));
			case 'satin-panties' | 'high' | 'milf':
				FlxTween.color(bg, 0.35, bg.color, FlxColor.fromRGB(203, 113, 170));
			case 'cocoa' | 'eggnog' | 'winter-horrorland': 
				FlxTween.color(bg, 0.35, bg.color, FlxColor.fromRGB(141, 165, 206));
			case 'senpai' | 'roses' | 'thorns': 
				FlxTween.color(bg, 0.35, bg.color, FlxColor.fromRGB(206, 106, 169));
			case 'ugh' | 'guns' | 'stress': 
				FlxTween.color(bg, 0.35, bg.color, FlxColor.GRAY);
			default: 
				//do nothing lol
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.15));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;

		scoreText.x = FlxG.width - scoreText.width - 6;

		scoreBG.scale.x = FlxG.width - scoreText.x + 6;
		scoreBG.x = FlxG.width - (scoreBG.scale.x / 2);
		diffText.x = Std.int(scoreBG.x + (scoreBG.width / 2));
		diffText.x -= diffText.width / 2;

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

		if (controls.LEFT_P)
			changeDiff(-1);
		if (controls.RIGHT_P)
			changeDiff(1);

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			if (iRestarted)
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
			FlxG.switchState(new MainMenuState());
		}

		if (songs[curSelected].songName.toLowerCase() == "extra-songs")
		{
			canAccept = false;
			if (FlxG.keys.justPressed.ENTER)
				regenMenu();
		}

		if (FlxG.keys.justPressed.ENTER && songs[curSelected].songName.toLowerCase() != stupidShit)
		{
			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);

			//trace(poop);

			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
			PlayState.isStoryMode = false;
			PlayState.isStoryMenu = false;
			PlayState.isFreeplayMenu = true;
			PlayState.storyDifficulty = curDifficulty;

			PlayState.storyWeek = songs[curSelected].week;
			//trace('CUR WEEK' + PlayState.storyWeek);
			FlxG.sound.music.fadeOut();
			LoadingState.loadAndSwitchState(new PlayState());
		}
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		#end

		switch (curDifficulty)
		{
			case 0:
				diffText.text = "< EASY >";
			case 1:
				diffText.text = '< NORMAL >';
			case 2:
				diffText.text = "< HARD >";
		}
	}

	function changeSelection(change:Int = 0)
	{
		#if !switch
		//NGio.logEvent('Fresh');
		#end

		FlxG.log.add(mainColor);

		// NGio.logEvent('Fresh');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;


		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		// lerpScore = 0;
		#end

		mainColor = songs[curSelected].songColor;

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.4;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
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
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var songColor:FlxColor = FlxColor.WHITE;

	public function new(song:String, week:Int, songCharacter:String, songColor:FlxColor)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.songColor = songColor;
	}
}
