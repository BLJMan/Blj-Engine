package;

import flixel.math.FlxRandom;
import flixel.graphics.FlxGraphic;
import lime.app.Application;
import io.newgrounds.components.ScoreBoardComponent;
#if desktop
import Discord.DiscordClient;
#end
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;

using StringTools;

class PlayState extends MusicBeatState
{
	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;

	public static var isStoryMenu:Bool = false;
	public static var isFreeplayMenu:Bool = false;

	public static var freeplayShit:Bool = false;

	var halloweenLevel:Bool = false;

	private var vocals:FlxSound;

	var time:Float = 0.15;

	private var dad:Character;
	private var dad2:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];
	public var eventNotes:Array<Dynamic> = [];

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	var isGFSection:Bool = false; 

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	private var SplashNote:NoteSplash;

	private var strumLineNotes:FlxTypedGroup<FlxSprite>;
	private var playerStrums:FlxTypedGroup<StrumNote>;
	private var cpuStrums:FlxTypedGroup<StrumNote>;
	private var grpNoteSplashes:FlxTypedGroup<NoteSplash>;

	var noteSplashOp:Bool;

	var mashViolations:Int = 0;
	var mashing:Int = 0;

	var grayThingy:FlxSprite;

	var funpillarts1ANIM:FlxSprite;
	var funpillarts2ANIM:FlxSprite;
	var funboppers1ANIM:FlxSprite;
	var funboppers2ANIM:FlxSprite;

	var tank0:FlxSprite;
	var tank1:FlxSprite;
	var tank2:FlxSprite;
	var tank3:FlxSprite;
	var tank4:FlxSprite;
	var tank5:FlxSprite;
	var tower:FlxSprite;

	private var zoomBack:Bool = false;
	private var camZooming:Bool = false;
	private var reverseZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;
	public var accuracy:Float = 0.00;
	private var accuracyDefault:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalNotesHitDefault:Float = 0;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	public static var isPixelArrows:Bool;

	//var daSplash:FlxSprite;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;
	public static var changedDifficulty:Bool = false;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	private var camDisplaceX:Float = 0;
	private var camDisplaceY:Float = 0;

	private var updateTime:Bool = true;
	//private var songLength:Float = 0;
	private var songPercent:Float = 0;

	public static var theFunne:Bool = true;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;

	var timeTxt:FlxText;
	var botTxt:FlxText;

	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var spinArray:Array<Int> = [272, 276, 336, 340, 400, 404, 464, 468, 528, 532, 592, 596, 656, 660, 720, 724, 784, 788, 848, 852, 912, 916, 976, 980, 1040, 1044, 1104, 1108, 1424, 1428, 1488, 1492, 1552, 1556, 1616, 1620];

	var talking:Bool = true;
	var songScore:Int = 0;
	var scoreTxt:FlxText;
	var misses:Int = 0;
	var noteHits:Float = 0;
	var missText:FlxText;

	var usedBotplay = false;

	var noScore:Bool = false;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;
	var defaultHUDZoom:Float = 1;

	var camForced:Bool = false;

	public static var oldInput:Bool = false;
	public static var dfjk:Bool = false;           

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;

	var inCutscene:Bool = false;

	var freeAnimation:Bool = false;

	var picoStep:Ps;
	var totalNotes:Int = 0;
	public static var notesForNow:Int = 0;
	//var tankStep:Ts;

	var bgspec:FlxSprite;

	var songLength:Float = 0;

	var noAnimate:Bool = false;

	var songNameBox:FlxSprite;
	var textThing:FlxText;
	var brightnessBox:FlxSprite;

	var floatshit:Float = 0;

	var camLikeMilf = false;
	var camBack = false;

	var daLerpVal:Float = (60 / FlxG.drawFramerate);

	#if desktop
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	//var songLength:Float = 0;
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	override public function create()
	{
		if (curSong != SONG.song)
		{
			if (SONG.song.toLowerCase() == "triple-trouble")
			{
				dad = new Character(61.15, -94.75, 'beast');
				add(dad);
				remove(dad);

				dad = new Character(61.15, -94.75, 'knucks');
				add(dad);
				remove(dad);

				dad = new Character(61.15, -94.75, 'egg');
				add(dad);
				remove(dad);

				dad = new Character(61.15, -94.75, 'tails');
				add(dad);
				remove(dad);

				boyfriend = new Boyfriend(466.1, 685.6 - 300, 'bfTT');
				add(boyfriend);
				remove(boyfriend);

			}
		}

		//FlxG.sound.cache(Paths.inst(SONG.song));
		//FlxG.sound.cache(Paths.voices(SONG.song));

		theFunne = CoolThings.ghost;

		FlxG.watch.addQuick("persist", FlxGraphic.defaultPersist);

		switch (SONG.song.toLowerCase())
		{
			case "megalo-strike-back": 
				CoolUtil.arrowHSV = [[40, 20, -30], [180, 20, -50], [-120, 20, -50], [0, 20, -50]];
			
			case "haxxer": 
				CoolUtil.arrowHSV = [[0, 10, 20], [0, 10, 20], [0, 10, 20], [0, 10, 20]];
			
			case "endless" | "bb": 
				CoolUtil.arrowHSV = [[-80, 10, -10], [50, 0, -30], [110, 0, -20], [-110, 10, -10]];

			case "ballistic": 
				CoolUtil.arrowHSV = [[0, -100, -20], [0, -100, -20], [0, -100, -20], [0, -100, -20]];
			
			default: 
				CoolUtil.arrowHSV = CoolUtil.fakeArrowHSV;
		}
		
		picoStep = Json.parse(openfl.utils.Assets.getText("assets/data/stress/picospeaker.json"));

		if (SONG.arrows == "pixel")
			isPixelArrows = true;
		else 
			isPixelArrows = false;

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();

		var sploosh = new NoteSplash(100, 100, 0);
		sploosh.alpha = 0;
		sploosh.antialiasing = CoolThings.antialiasing;
		grpNoteSplashes.add(sploosh);
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			sploosh.alpha = 0.6;
		});

		FlxCamera.defaultCameras = [camGame];
		//FlxG.cameras.setDefaultDrawTarget(camGame, true);

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		if (SONG.events == null)
		{
			SONG.events = [new SongEvent(0, SONG.bpm, null, "BPMChange", "0,0")];
		}

		switch (SONG.song.toLowerCase())
		{
			case 'tutorial':
				dialogue = ["Hey you're pretty cute.", 'Use the arrow keys to keep up \nwith me singing.'];
			case 'bopeebo':
				dialogue = [
					'HEY!',
					"You think you can just sing\nwith my daughter like that?",
					"If you want to date her...",
					"You're going to have to go \nthrough ME first!"
				];
			case 'fresh':
				dialogue = ["Not too shabby boy.", ""];
			case 'dadbattle':
				dialogue = [
					"gah you think you're hot stuff?",
					"If you can beat me here...",
					"Only then I will even CONSIDER letting you\ndate my daughter!"
				];
			case 'senpai':
				dialogue = CoolUtil.coolTextFile(Paths.txt('senpai/senpaiDialogue'));
			case 'roses':
				dialogue = CoolUtil.coolTextFile(Paths.txt('roses/rosesDialogue'));
			case 'thorns':
				dialogue = CoolUtil.coolTextFile(Paths.txt('thorns/thornsDialogue'));
		}

		#if desktop
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Easy";
			case 1:
				storyDifficultyText = "Normal";
			case 2:
				storyDifficultyText = "Hard";
		}

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
			case "tankman":
				iconRPC = "tankman";
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;
		
		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
		#end
		if (SONG.stage == null)
		{
			switch (SONG.song.toLowerCase())
			{
				case 'spookeez' | 'monster' | 'south': 
					curStage = 'spooky';

				case 'pico' | 'blammed' | 'philly': 
					curStage = 'philly';

				case 'milf' | 'satin-panties' | 'high':
					curStage = 'limo';

				case 'cocoa' | 'eggnog':
					curStage = 'mall';

				case 'winter-horrorland':
					curStage = 'mallEvil';

				case 'senpai' | 'roses':
					curStage = 'school';

				case "ugh" | "guns" | "stress":
					curStage = 'tankStage';

				case 'megalo-strike-back':
					curStage = 'murder';

				case 'thorns':
					curStage = 'schoolEvil';

				case "endless": 
					curStage = "sonicfunStage";

				default:
					curStage = 'stage';

			}
		}else 
		{
			curStage = SONG.stage;
		}

		switch (curStage)
		{
            case 'spooky': 
            {
				halloweenLevel = true;

				var hallowTex = Paths.getSparrowAtlas('halloween_bg');

				halloweenBG = new FlxSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = CoolThings.antialiasing;
				add(halloweenBG);

		    	isHalloween = true;
		    }
		    case 'philly': 
            {

		    	var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky'));
		        bg.scrollFactor.set(0.1, 0.1);
		        add(bg);

	            var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city'));
		        city.scrollFactor.set(0.3, 0.3);
		        city.setGraphicSize(Std.int(city.width * 0.85));
		        city.updateHitbox();
		        add(city);

		        phillyCityLights = new FlxTypedGroup<FlxSprite>();
		        add(phillyCityLights);

		        for (i in 0...5)
		        {
		            var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i));
		            light.scrollFactor.set(0.3, 0.3);
		            light.visible = false;
		            light.setGraphicSize(Std.int(light.width * 0.85));
		            light.updateHitbox();
		            light.antialiasing = CoolThings.antialiasing;
		            phillyCityLights.add(light);
		        }

		        var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain'));
		        add(streetBehind);

	            phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train'));
		        add(phillyTrain);

		        trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
		        FlxG.sound.list.add(trainSound);

		        // var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

		        var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street'));
	            add(street);
		    }
		    case 'limo':
		    {
		    	defaultCamZoom = 0.90;

		        var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset'));
		        skyBG.scrollFactor.set(0.1, 0.1);
		        add(skyBG);

		        var bgLimo:FlxSprite = new FlxSprite(-200, 480);
		        bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo');
		        bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
		        bgLimo.animation.play('drive');
		        bgLimo.scrollFactor.set(0.4, 0.4);
		        add(bgLimo);

		        grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
		        add(grpLimoDancers);

		        for (i in 0...5)
		        {
		            var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
		            dancer.scrollFactor.set(0.4, 0.4);
		            grpLimoDancers.add(dancer);
		        }

		        var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('limo/limoOverlay'));
		        overlayShit.alpha = 0.5;
		        // add(overlayShit);

		        // var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

		        // FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

		        //overlayShit.shader = shaderBullshit;

		        var limoTex = Paths.getSparrowAtlas('limo/limoDrive');

		        limo = new FlxSprite(-120, 550);
		        limo.frames = limoTex;
		        limo.animation.addByPrefix('drive', "Limo stage", 24);
		        limo.animation.play('drive');
		        limo.antialiasing = CoolThings.antialiasing;

		        fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol'));
		        // add(limo);
		    }
		    case 'mall':
			{

		    	defaultCamZoom = 0.80;

		        var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls'));
		        bg.antialiasing = CoolThings.antialiasing;
		        bg.scrollFactor.set(0.2, 0.2);
		        bg.active = false;
		        bg.setGraphicSize(Std.int(bg.width * 0.8));
		        bg.updateHitbox();
		        add(bg);

		    	upperBoppers = new FlxSprite(-240, -90);
		        upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop');
		        upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
		        upperBoppers.antialiasing = CoolThings.antialiasing;
		        upperBoppers.scrollFactor.set(0.33, 0.33);
		        upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
		        upperBoppers.updateHitbox();
		        add(upperBoppers);

		        var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator'));
		        bgEscalator.antialiasing = CoolThings.antialiasing;
		        bgEscalator.scrollFactor.set(0.3, 0.3);
		        bgEscalator.active = false;
		        bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
		        bgEscalator.updateHitbox();
		        add(bgEscalator);

		        var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree'));
		        tree.antialiasing = CoolThings.antialiasing;
		        tree.scrollFactor.set(0.40, 0.40);
		        add(tree);

		        bottomBoppers = new FlxSprite(-300, 140);
		        bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop');
		        bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
		        bottomBoppers.antialiasing = CoolThings.antialiasing;
	            bottomBoppers.scrollFactor.set(0.9, 0.9);
	            bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
		        bottomBoppers.updateHitbox();
		        add(bottomBoppers);

		    	var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow'));
		        fgSnow.active = false;
		        fgSnow.antialiasing = CoolThings.antialiasing;
		        add(fgSnow);

		        santa = new FlxSprite(-840, 150);
		        santa.frames = Paths.getSparrowAtlas('christmas/santa');
		        santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
		        santa.antialiasing = CoolThings.antialiasing;
		        add(santa);
		    }
		    case 'mallEvil':
		    {
		        var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG'));
		        bg.antialiasing = CoolThings.antialiasing;
		        bg.scrollFactor.set(0.2, 0.2);
		        bg.active = false;
		        bg.setGraphicSize(Std.int(bg.width * 0.8));
		        bg.updateHitbox();
		        add(bg);

		        var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree'));
		        evilTree.antialiasing = CoolThings.antialiasing;
		        evilTree.scrollFactor.set(0.2, 0.2);
		        add(evilTree);

		        var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow"));
	            evilSnow.antialiasing = CoolThings.antialiasing;
		        add(evilSnow);
            }
		    case 'school':
		    {

		    	// defaultCamZoom = 0.9;

		        var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky'));
		        bgSky.scrollFactor.set(0.1, 0.1);
		        add(bgSky);

		        var repositionShit = -200;

		        var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool'));
		        bgSchool.scrollFactor.set(0.6, 0.90);
		        add(bgSchool);

		        var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet'));
		        bgStreet.scrollFactor.set(0.95, 0.95);
		        add(bgStreet);

		        var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack'));
		        fgTrees.scrollFactor.set(0.9, 0.9);
		        add(fgTrees);

		        var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
		        var treetex = Paths.getPackerAtlas('weeb/weebTrees');
		        bgTrees.frames = treetex;
		        bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
		        bgTrees.animation.play('treeLoop');
		        bgTrees.scrollFactor.set(0.85, 0.85);
		        add(bgTrees);

		        var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
		        treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals');
		        treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
		        treeLeaves.animation.play('leaves');
		        treeLeaves.scrollFactor.set(0.85, 0.85);
		        add(treeLeaves);

		        var widShit = Std.int(bgSky.width * 6);

		        bgSky.setGraphicSize(widShit);
		        bgSchool.setGraphicSize(widShit);
		        bgStreet.setGraphicSize(widShit);
		        bgTrees.setGraphicSize(Std.int(widShit * 1.4));
		        fgTrees.setGraphicSize(Std.int(widShit * 0.8));
		        treeLeaves.setGraphicSize(widShit);

		        fgTrees.updateHitbox();
		        bgSky.updateHitbox();
		        bgSchool.updateHitbox();
		        bgStreet.updateHitbox();
		        bgTrees.updateHitbox();
		        treeLeaves.updateHitbox();

		        bgGirls = new BackgroundGirls(-100, 190);
		        bgGirls.scrollFactor.set(0.9, 0.9);

		        if (SONG.song.toLowerCase() == 'roses')
	            {
		        	bgGirls.getScared();
		        }

		        bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
		        bgGirls.updateHitbox();
		        add(bgGirls);
		    }

			case "tankStage":
			{
				defaultCamZoom = 0.9;
				var bg:FlxSprite = new FlxSprite(-300, -240).loadGraphic(Paths.image('tankSky'));
				bg.setGraphicSize(Std.int(bg.width * 1.1));
		        bg.updateHitbox();
				bg.antialiasing = CoolThings.antialiasing;
				bg.scrollFactor.set(0.1, 0.9);
				bg.active = false;
				add(bg);

				var stageFront:FlxSprite = new FlxSprite(-400, -80).loadGraphic(Paths.image('tankMountains'));
				stageFront.antialiasing = CoolThings.antialiasing;
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.5));
		        stageFront.updateHitbox();
				stageFront.scrollFactor.set(0.4, 0.4);
				stageFront.active = false;
				add(stageFront);

				var stageCurtains:FlxSprite = new FlxSprite(-600, -50).loadGraphic(Paths.image('tankRuins'));
				stageCurtains.antialiasing = CoolThings.antialiasing;
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 1.5));
		        stageCurtains.updateHitbox();
				stageCurtains.scrollFactor.set(0.5, 0.5);
				stageCurtains.active = false;

				add(stageCurtains);

				tower = new FlxSprite(-100, -40);
		        tower.frames = Paths.getSparrowAtlas('tankWatchtower');
		        tower.animation.addByPrefix('bop', 'watchtower gradient color instance 1', 24, false);
		        tower.scrollFactor.set(0.6, 0.6);
				tower.antialiasing = CoolThings.antialiasing;
		        add(tower);

				var smokeLeft:FlxSprite = new FlxSprite(-350, -40);
		        smokeLeft.frames = Paths.getSparrowAtlas('smokeLeft');
		        smokeLeft.animation.addByPrefix('smok', 'SmokeBlurLeft instance 1', 24, true);
		        smokeLeft.animation.play('smok');
		        smokeLeft.scrollFactor.set(0.6, 0.6);
				smokeLeft.antialiasing = CoolThings.antialiasing;
		        add(smokeLeft);

				var smokeRight:FlxSprite = new FlxSprite(1250, -40);
		        smokeRight.frames = Paths.getSparrowAtlas('smokeRight');
		        smokeRight.animation.addByPrefix('smok', 'SmokeRight instance 1', 24, true);
		        smokeRight.animation.play('smok');
		        smokeRight.scrollFactor.set(0.6, 0.6);
				smokeRight.alpha = 0.6;
				smokeRight.antialiasing = CoolThings.antialiasing;
		        add(smokeRight);


				var ground:FlxSprite = new FlxSprite(-450, -180).loadGraphic(Paths.image('tankGround'));
				ground.setGraphicSize(Std.int(ground.width * 1.2));
		        ground.updateHitbox();
				ground.antialiasing = CoolThings.antialiasing;
				ground.scrollFactor.set(0.9, 0.9);
				ground.active = false;
				add(ground);

				tank0 = new FlxSprite(-200, 600);
				tank0.frames = Paths.getSparrowAtlas("tank0");
				tank0.animation.addByPrefix("bop", "fg tankhead far right instance", 24, false);
				tank0.scrollFactor.set(0.7, 0.7);
				tank0.antialiasing = true;
				
				tank1 = new FlxSprite(-40, 800);
				tank1.frames = Paths.getSparrowAtlas("tank1");
				tank1.animation.addByPrefix("bop", "fg tankhead 5 instance 1", 24, false);
				tank1.scrollFactor.set(0.5, 0.5);
				tank1.antialiasing = true;
						

				tank2 = new FlxSprite(350, 700);
				tank2.frames = Paths.getSparrowAtlas("tank2");
				tank2.animation.addByPrefix("bop", "foreground man 3 instance 1", 24, false);
				tank2.scrollFactor.set(0.7, 0.7);
				tank2.antialiasing = true;
						

				tank3 = new FlxSprite(520, 800);
				tank3.frames = Paths.getSparrowAtlas("tank3");
				tank3.animation.addByPrefix("bop", "fg tankhead 4 instance 1", 24, false);
				tank3.scrollFactor.set(0.5, 0.5);
				tank3.antialiasing = true;
						

				tank4 = new FlxSprite(1020, 700);
				tank4.frames = Paths.getSparrowAtlas("tank4");
				tank4.animation.addByPrefix("bop", "fg tankman bobbin 3 instance 1", 24, false);
				tank4.scrollFactor.set(0.7, 0.7);
				tank4.antialiasing = true;
						

				tank5 = new FlxSprite(1350, 610);
				tank5.frames = Paths.getSparrowAtlas("tank5");
				tank5.animation.addByPrefix("bop", "fg tankhead far right instance 1", 24, false);
				tank5.scrollFactor.set(0.7, 0.7);
				tank5.antialiasing = true;
						
			}

			case 'murder':
            {
				defaultCamZoom = 0.9;

				var bg:FlxSprite = new FlxSprite(-320, -150);
				bg.loadGraphic(Paths.image('chara-bg'));
				bg.antialiasing = CoolThings.antialiasing;
				bg.scale.set(1.1, 1.1);
				bg.scrollFactor.set(0.9, 0.9);
				add(bg);
		    }

		    case 'schoolEvil':
		    {

		        var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
		        var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

		        var posX = 400;
	            var posY = 200;

		        var bg:FlxSprite = new FlxSprite(posX, posY);
		        bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool');
		        bg.animation.addByPrefix('idle', 'background 2', 24);
		    	bg.animation.play('idle');
		        bg.scrollFactor.set(0.8, 0.9);
		        bg.scale.set(6, 6);
		        add(bg);


		                   
		        /* var bg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolBG'));
		        bg.scale.set(6, 6);
		        // bg.setGraphicSize(Std.int(bg.width * 6));
		        // bg.updateHitbox();
		        add(bg);

		        var fg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolFG'));
		        fg.scale.set(6, 6);
		        // fg.setGraphicSize(Std.int(fg.width * 6));
		    	// fg.updateHitbox();
		        add(fg);

		        wiggleShit.effectType = WiggleEffectType.DREAMY;
		        wiggleShit.waveAmplitude = 0.01;
		        wiggleShit.waveFrequency = 60;
		        wiggleShit.waveSpeed = 0.8;
		                    

		        bg.shader = wiggleShit.shader;
		        fg.shader = wiggleShit.shader;

		                  
		        var waveSprite = new FlxEffectSprite(bg, [waveEffectBG]);
		        var waveSpriteFG = new FlxEffectSprite(fg, [waveEffectFG]);

		        // Using scale since setGraphicSize() doesnt work???
		        waveSprite.scale.set(6, 6);
		        waveSpriteFG.scale.set(6, 6);
		        waveSprite.setPosition(posX, posY);
		        waveSpriteFG.setPosition(posX, posY);

		        waveSprite.scrollFactor.set(0.7, 0.8);
		        waveSpriteFG.scrollFactor.set(0.9, 0.8);

		        // waveSprite.setGraphicSize(Std.int(waveSprite.width * 6));
		        // waveSprite.updateHitbox();
		        // waveSpriteFG.setGraphicSize(Std.int(fg.width * 6));
		        // waveSpriteFG.updateHitbox();

		        add(waveSprite);
		        add(waveSpriteFG);*/
		                    
		    }

			case 'sonicfunStage':
			{
				defaultCamZoom = 0.9;

				var funsky:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('sonicFUNsky'));
				funsky.setGraphicSize(Std.int(funsky.width * 0.9));
				funsky.antialiasing = true;
				funsky.scrollFactor.set(0.3, 0.3);
				funsky.active = false;
				add(funsky);

				var funbush:FlxSprite = new FlxSprite(-42, 171).loadGraphic(Paths.image('Bush2'));
				funbush.antialiasing = true;
				funbush.scrollFactor.set(0.3, 0.3);
				funbush.active = false;
				add(funbush);

				funpillarts2ANIM = new FlxSprite(182, -100); // Zekuta why...
				funpillarts2ANIM.frames = Paths.getSparrowAtlas('Majin Boppers Back');
				funpillarts2ANIM.animation.addByPrefix('bumpypillar', 'MajinBop2 instance 1', 24);
				// funpillarts2ANIM.setGraphicSize(Std.int(funpillarts2ANIM.width * 0.7));
				funpillarts2ANIM.antialiasing = true;
				funpillarts2ANIM.scrollFactor.set(0.6, 0.6);
				add(funpillarts2ANIM);

				var funbush2:FlxSprite = new FlxSprite(132, 354).loadGraphic(Paths.image('Bush 1'));
				funbush2.antialiasing = true;
				funbush2.scrollFactor.set(0.3, 0.3);
				funbush2.active = false;
				add(funbush2);

				funpillarts1ANIM = new FlxSprite(-169, -167);
				funpillarts1ANIM.frames = Paths.getSparrowAtlas('Majin Boppers Front');
				funpillarts1ANIM.animation.addByPrefix('bumpypillar', 'MajinBop1 instance 1', 24);
				// funpillarts1ANIM.setGraphicSize(Std.int(funpillarts1ANIM.width * 0.7));
				funpillarts1ANIM.antialiasing = true;
				funpillarts1ANIM.scrollFactor.set(0.6, 0.6);
				add(funpillarts1ANIM);

				var funfloor:FlxSprite = new FlxSprite(-340, 660).loadGraphic(Paths.image('floor BG'));
				funfloor.antialiasing = true;
				funfloor.scrollFactor.set(0.5, 0.5);
				funfloor.active = false;
				add(funfloor);

				funboppers1ANIM = new FlxSprite(1126, 903);
				funboppers1ANIM.frames = Paths.getSparrowAtlas('majin FG1');
				funboppers1ANIM.animation.addByPrefix('bumpypillar', 'majin front bopper1', 24);
				funboppers1ANIM.antialiasing = true;
				funboppers1ANIM.scrollFactor.set(0.8, 0.8);

				funboppers2ANIM = new FlxSprite(-293, 871);
				funboppers2ANIM.frames = Paths.getSparrowAtlas('majin FG2');
				funboppers2ANIM.animation.addByPrefix('bumpypillar', 'majin front bopper2', 24);
				funboppers2ANIM.antialiasing = true;
				funboppers2ANIM.scrollFactor.set(0.8, 0.8);
			}

			case 'stage':
			{
				defaultCamZoom = 0.9;
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
				bg.antialiasing = CoolThings.antialiasing;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = CoolThings.antialiasing;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				add(stageFront);

				var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = CoolThings.antialiasing;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;

				add(stageCurtains);
			}

			case 'sonicexeStage': // i fixed the bgs and shit!!! - razencro part 1
			{
				defaultCamZoom = 0.9;

				var sSKY:FlxSprite = new FlxSprite(-414, -440.8).loadGraphic(Paths.image('sky'));
				sSKY.antialiasing = true;
				sSKY.scrollFactor.set(1, 1);
				sSKY.active = false;
				sSKY.scale.x = 1.4;
				sSKY.scale.y = 1.4;
				add(sSKY);

				var trees:FlxSprite = new FlxSprite(-290.55, -298.3).loadGraphic(Paths.image('backtrees'));
				trees.antialiasing = true;
				trees.scrollFactor.set(1.1, 1);
				trees.active = false;
				trees.scale.x = 1.2;
				trees.scale.y = 1.2;
				add(trees);

				var bg2:FlxSprite = new FlxSprite(-306, -334.65).loadGraphic(Paths.image('trees'));
				bg2.updateHitbox();
				bg2.antialiasing = true;
				bg2.scrollFactor.set(1.2, 1);
				bg2.active = false;
				bg2.scale.x = 1.2;
				bg2.scale.y = 1.2;
				add(bg2);

				var bg:FlxSprite = new FlxSprite(-309.95, -240.2).loadGraphic(Paths.image('ground'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1.3, 1);
				bg.active = false;
				bg.scale.x = 1.2;
				bg.scale.y = 1.2;
				add(bg);

				bgspec = new FlxSprite(-428.5 + 50 + 700, -449.35 + 25 + 392 + 105 + 50).loadGraphic(Paths.image("GreenHill"));
				bgspec.antialiasing = false;
				bgspec.scrollFactor.set(1, 1);
				bgspec.active = false;
				bgspec.visible = false;
				bgspec.scale.x = 8;
				bgspec.scale.y = 8;
				add(bgspec);
			}

			case "mountains": 
			{
				defaultCamZoom = 0.5;

				var floor = new FlxSprite(-666.7, 338.2).loadGraphic(Paths.image("floor"));
				var mountainsbg = new FlxSprite(-1025.8, -116.05).loadGraphic(Paths.image("mountainsbg"));
				var mountainsmg = new FlxSprite(-1490.1, -592.75).loadGraphic(Paths.image("mountainsmg"));
				var sky = new FlxSprite(-1130.75, -1093.5).loadGraphic(Paths.image("skyHark"));
				floor.scrollFactor.set(0.9, 0.9);
				mountainsbg.scrollFactor.set(0.2, 0.2);
				mountainsmg.scrollFactor.set(0.4, 0.4);
				sky.scrollFactor.set(0, 0);
				add(sky);
				add(mountainsbg);
				add(mountainsmg);
				add(floor);
			}

		    default:
		    {
		        defaultCamZoom = 0.9;
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
				bg.antialiasing = CoolThings.antialiasing;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = CoolThings.antialiasing;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				add(stageFront);

				var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = CoolThings.antialiasing;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;

				add(stageCurtains);
            }

		}

		gf = new Character(400, 130, SONG.gf);
		gf.scrollFactor.set(0.95, 0.95);

		dad = new Character(100, 100, SONG.player2);
		//dad2 = new Character(150, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(gf.getGraphicMidpoint().x, gf.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case "tankman":
				dad.y += 210;
				camPos.y +=300;
			case "chara":
				dad.y += 300;
				camPos.y -= 200;
			case "crewmate":
				dad.y += 380;
			case "glitched-bob": 
				dad.y += 280;
			case 'sonic.exe alt':
				camPos.set(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y - 400);
			case "tails": 
				dad.y += 300;
		}

		boyfriend = new Boyfriend(770, 450, SONG.player1);

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;

				resetFastCar();
				add(fastCar);

			case 'mall':
				boyfriend.x += 200;

			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case "tankStage":
				boyfriend.x += 150;
				gf.x -= 95;
				gf.y -= 30;
			case "tankStageAlt":
				boyfriend.x += 150;
				gf.x -= 10;
				gf.y -= 153;
			case 'schoolEvil':
				// trailArea.scrollFactor.set();

				var evilTrail = new FlxTrail(dad, null, 6, 24, 0.4, 0.055);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);

				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'sonicfunStage': 
				boyfriend.y += 334;
				boyfriend.x += 80;
				dad.y += 470;
				gf.y += 300;
				//camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y - 200);
			case "mountains": 
				boyfriend.setPosition(992.6, 264.15);
				gf.setPosition(405.4, -139.1);
				dad.setPosition(102.45, 113);
		}

		switch (SONG.gf)
		{
			case 'picoSpeaker': 
				gf.x -= 10;
				gf.y -= 153;
		}

		add(gf);

		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

		add(dad);
		//add(dad2);
		add(boyfriend);

		if (curStage == 'sonicfunStage')
		{
			add(funboppers1ANIM);
			add(funboppers2ANIM);
			gf.visible = false;
		}

		if (SONG.song.toLowerCase() == "onslaught" || SONG.song.toLowerCase() == "run" || SONG.song.toLowerCase() == "you-cant-run" || SONG.song.toLowerCase() == "triple-trouble" || SONG.song.toLowerCase() == "obsolete")
		{
			gf.visible = false;
		}

		if (curStage == 'tankStage')
		{
			add(tank0);
			add(tank2);
			add(tank4);
			add(tank5);
			add(tank1);
			add(tank3);
		}

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;

		grayThingy = new FlxSprite(0, 657);
		grayThingy.makeGraphic(FlxG.width, 300, FlxColor.BLACK);
		grayThingy.alpha = 0.35;
		grayThingy.scrollFactor.set();
		add(grayThingy);

		//songNameBox = new FlxSprite(-200, 580).loadGraphic(Paths.image("box", "shared"), false, SONG.song.length * 12, 70);
		songNameBox = new FlxSprite(-200, 690).makeGraphic(SONG.song.length * 12, 30, FlxColor.GRAY);
		songNameBox.cameras = [camHUD];
		songNameBox.updateHitbox();
		songNameBox.alpha = 0;
		songNameBox.antialiasing = CoolThings.antialiasing;
		add(songNameBox);

		textThing = new FlxText(songNameBox.x + 10, songNameBox.y + 5, 0, SONG.song);
		textThing.cameras = [camHUD];
		textThing.scale.set(1.1, 1.1);
		textThing.alpha = 0;
		textThing.antialiasing = CoolThings.antialiasing;
		textThing.setFormat(Paths.font("funkin.otf"), 18, FlxColor.BLACK, RIGHT);
		add(textThing);

		if (CoolThings.downscroll)
		{
			grayThingy.y = -183;
		}
		

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();

		timeTxt = new FlxText(FlxG.width / 2 - 200, strumLine.y + 40, 400, "", 40);
		timeTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeTxt.scrollFactor.set();
		timeTxt.alpha = 0;
		timeTxt.borderSize = 2;
		timeTxt.visible = CoolThings.showtime;
		timeTxt.antialiasing = CoolThings.antialiasing;
		add(timeTxt);

		
		botTxt = new FlxText(FlxG.width / 2 - 200, strumLine.y + 100, 400, "BOTPLAY", 40);
		botTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		botTxt.scrollFactor.set();
		botTxt.borderSize = 2;
		botTxt.antialiasing = CoolThings.antialiasing;
		add(botTxt);

		updateTime = true;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);
		add(grpNoteSplashes);

		//var splash:NoteSplash = new NoteSplash(100, 100, 0);
		//grpNoteSplashes.add(splash);
		//splash.alpha = 0.0;

		playerStrums = new FlxTypedGroup<StrumNote>();
		cpuStrums = new FlxTypedGroup<StrumNote>();

		if (CoolThings.downscroll)
			strumLine.y = FlxG.height - 165;

		// startCountdown();

		generateSong(SONG.song);

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.03 * daLerpVal);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;
		moveCameraSection(0);

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('UI/healthBar'));
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		if (CoolThings.downscroll)
			healthBarBG.y = 50;

		var color1:Int = 0xFFFF0000;
		var color2:Int = 0xFF66FF33;

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		// healthBar
		add(healthBar);

		switch (SONG.player2)
        {
			case 'bf' | "bf-car" | "bf-christmas" | "bf-pixel" | "bf-holding-gf": 
			color1 = 0xFF0097C4;

        	case 'gf' | "gf-car" | "gf-christmas" | "gf-pixel" | "gf-tankman":
			color1 = 0xFFFF0000;

        	case 'dad' | 'mom-car' | 'parents-christmas':
			color1 = 0xFF5A07F5;

        	case 'spooky':
			color1 = 0xFFF57E07;

        	case 'monster-christmas' | 'monster':
			color1 = 0xFFF5DD07;

        	case 'pico':
			color1 = 0xFF52B514;

        	case 'senpai' | 'senpai-angry':
			color1 = 0xFFF76D6D;

        	case 'spirit':
			color1 = 0xFFAD0505;

	    	case 'tankman':
			color1 = FlxColor.GRAY;

			case 'sonicfun': 
			color1 = FlxColor.BLUE;
        }

		switch (SONG.player1)
		{
			case 'bf' | "bf-car" | "bf-christmas" | "bf-pixel" | "bf-holding-gf": 
			color2 = 0xFF0097C4;

			case 'gf' | "gf-car" | "gf-christmas" | "gf-pixel" | "gf-tankman":
			color2 = 0xFFFF0000;

        	case 'dad' | 'mom-car' | 'parents-christmas':
		 	color2 = 0xFF5A07F5;

        	case 'spooky':
		 	color2 = 0xFFF57E07;

        	case 'monster-christmas' | 'monster':
			color2 = 0xFFF5DD07;

         	case 'pico':
			color2 = 0xFF52B514;

        	case 'senpai' | 'senpai-angry':
			color2 = 0xFFF76D6D;

        	case 'spirit':
			color2 = 0xFFAD0505;

	    	case 'tankman':
			color2 = FlxColor.GRAY;

			case 'sonicfun': 
			color2 = FlxColor.BLUE;
		}

		healthBar.createFilledBar(color1, color2);

		if (SONG.song.toLowerCase() == "sussus-toogus")
		{
			brightnessBox = new FlxSprite(-500, -400).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.RED);
			brightnessBox.alpha = 1;
			add(brightnessBox);
			new FlxTimer().start(0.1, function(tmr:FlxTimer)
			{
				brightnessBox.alpha = 0;
			});
		}

		scoreTxt = new FlxText(healthBarBG.x + healthBarBG.width - 210, healthBarBG.y + 45, 0, "", 20);
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT);
		scoreTxt.antialiasing = CoolThings.antialiasing;
		scoreTxt.scrollFactor.set();
		add(scoreTxt);

		missText = new FlxText(healthBarBG.x + healthBarBG.width - 210, healthBarBG.y + 30, 0, "", 20);
		missText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT);
		missText.antialiasing = CoolThings.antialiasing;
		missText.visible = CoolThings.showMiss;
		missText.scrollFactor.set();
		add(missText);

		var pogTxt = new FlxText(20, healthBarBG.y + 45, 0, curSong + " " + CoolUtil.difficultyString() + " | " + Application.current.meta.get('version') + " - FNF v0.2.7.1", 25);
		pogTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT);
		pogTxt.scrollFactor.set();
		pogTxt.antialiasing = CoolThings.antialiasing;
		if (isStoryMode)
			pogTxt.text = curSong + " " + CoolUtil.difficultyString();
		add(pogTxt);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		strumLineNotes.cameras = [camHUD];
		grpNoteSplashes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camHUD];
		pogTxt.cameras = [camHUD];
		grayThingy.cameras = [camHUD];
		missText.cameras = [camHUD];
		timeTxt.cameras = [camHUD];
		botTxt.cameras = [camHUD];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;

		if (isStoryMode)
		{
			switch (curSong.toLowerCase())
			{
				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case 'senpai':
					schoolIntro(doof);
				case 'roses':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'thorns':
					schoolIntro(doof);
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}

		super.create();
	}

	function spawnSongName()
	{
		FlxTween.tween(songNameBox, {x: 0, alpha: 1}, 0.5, {ease: FlxEase.circOut, startDelay: 0.2});
		FlxTween.tween(textThing, {x: 5, alpha: 1}, 0.6, {ease: FlxEase.circOut, startDelay: 0.2});

		new FlxTimer().start(3, function(tmr:FlxTimer)
		{
			FlxTween.tween(songNameBox, {x: -200, alpha: 0}, 0.6, {ease: FlxEase.circIn, startDelay: 0.2});
			FlxTween.tween(textThing, {x: -220, alpha: 0}, 0.6, {ease: FlxEase.circIn, startDelay: 0.2});
		});

	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	function startCountdown():Void
	{
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);
		//generateSplashes();

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();

			gf.dance();

			boyfriend.playAnim('idle');

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', ['ready-pixel', 'set-pixel', 'date-pixel']);
			introAssets.set('schoolEvil', ['ready-pixel', 'set-pixel', 'date-pixel']);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3'), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image("UI/" + introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2'), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image("UI/" + introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1'), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image("UI/" + introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo'), 0.6);
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		#if desktop
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped

		for (section in noteData)
		{
			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				if (daStrumTime < 0)
					daStrumTime = 0;
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				
				var daType = songNotes[3];

				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, daType);
				totalNotes ++;
				//trace("addedNote " + totalNotes);
				swagNote.sustainLength = songNotes[2];
				swagNote.gfNote = (section.gfSection && (songNotes[1]<4));
				swagNote.scrollFactor.set(0, 0);

				swagNote.mustPress = gottaHitNote;

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					totalNotes ++;
					sustainNote.scrollFactor.set();
					sustainNote.gfNote = (section.gfSection && (songNotes[1]<4));
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += (FlxG.width / 2) + 50; // general offset
					}else 
					{
						sustainNote.x += 50;
					}
				}

				if (swagNote.mustPress)
				{
					swagNote.x += (FlxG.width / 2) + 50; // general offset
				}
				else 
				{
					swagNote.x += 50;
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			//var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);
			var babyArrow:StrumNote = new StrumNote(0, strumLine.y, i, player);
			//babyArrow.alpha = 0.6;

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			babyArrow.alpha = 0;
			babyArrow.y -= 10;
			babyArrow.alpha = 0;
			timeTxt.alpha = 0;
			FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			FlxTween.tween(timeTxt, {alpha: 1}, 1, {startDelay: 1});

			babyArrow.ID = i;

			switch (player)
			{
				case 0:
					cpuStrums.add(babyArrow);
				case 1:
					playerStrums.add(babyArrow);
			}

			/*babyArrow.animation.play('static');
			babyArrow.x += 100;
			babyArrow.x += ((FlxG.width / 2) * (player));*/

			/*cpuStrums.forEach(function(spr:FlxSprite)
			{					
				spr.centerOffsets(); //CPU arrows start out slightly off-center
			});*/

			strumLineNotes.add(babyArrow);
			babyArrow.afterGenerating();
		}
	}


	function tweenCamIn():Void
	{
		zoomBack = false;
		camZooming = false;
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if desktop
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			}
			#end
		}

		super.closeSubState();
	}

	override public function onFocus():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			if (Conductor.songPosition > 0.0)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			}
		}
		#end

		super.onFocus();
	}
	
	override public function onFocusLost():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
		}
		#end
		persistentUpdate = false;
		persistentDraw = true;
		paused = true;

		if(canPause)
			//openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

		super.onFocusLost();
	}

	function flashRed()
	{
		brightnessBox.alpha = 0.3;
		FlxTween.tween(brightnessBox, {alpha: 0}, 0.3, {startDelay: 0.3});
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	var strumVis:Bool = true;
	var healthVis:Bool = true;

	public static var strumAddX:Int = 0;

	var lul:Float = 0;

	override public function update(elapsed:Float)
	{
		FlxG.watch.addQuick("q", boyfriend.holdTimer);
		FlxG.watch.addQuick("freeAnim", freeAnimation);
		FlxG.watch.addQuick("no", songScore + " / " + noteHits + " / " + misses + " / " + accuracy);

		accuracy = FlxMath.roundDecimal((songScore / ((noteHits + misses) * 350)) * 100, 2); 

		/*if (FlxG.keys.pressed.L)
		{
			FlxG.sound.music.pause();
			vocals.pause();
		}else if (FlxG.keys.justReleased.L)
		{
			FlxG.sound.music.resume();
			vocals.resume();
		}*/

		if (SONG.song == "bb")
		{
			noScore = true;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null && !endingSong && !camForced)
		{
			moveCameraSection(Std.int(curStep / 16));
		}

		if (Math.isNaN(accuracy))
			accuracy = 0;

		for (event in SONG.events)
		{
			var daStep:Float = event.position;
			var daVal1:Float = event.value1;
			var daVal2:String = event.value2;
			var daType = event.type;

			if (curStep == daStep)
			{
				trace("WOAH WTF ITS ACTUALLY WORKIN");
				switch (daType)
				{
					case "BPMChange":
					{
						Conductor.changeBPM(Std.int(daVal1));
						FlxG.log.add('CHANGED BPM!');
						trace("called change bpm event");
					}
					case "speedChange": 
					{
						SONG.speed = daVal1;
						trace("called change scroll speed event");
					}
					case "characterChange": 
					{
						switchCharacter(Std.string(daVal1), daVal2);
						trace("called change character event");
					}
					case "playAnim": 
					{
						switch(daVal1)
						{
							case 1: 
								noAnimate = true;
								freeAnimation = true;
								dad.playAnim(daVal2, true);
							case 2: 
								boyfriend.playAnim(daVal2, true);
							case 3: 
								gf.playAnim(daVal2, true);
						}
						trace("called play anim event");
						
					}
					case "hey": 
					{
						boyfriend.playAnim("hey", true);
						if (dad.curCharacter != "gf")
							gf.playAnim("cheer", true);
						else if (dad.curCharacter == "gf")
							dad.playAnim("cheer", true);

						trace("called hey event");
					}
					case "addZoom": 
					{
						FlxG.camera.zoom += daVal1;
						camHUD.zoom += Std.parseFloat(daVal2);
						trace("called add camera zoom event");
					}
					case "zoomOnBeat": 
					{
						camLikeMilf = true;
						camBack = false;

						trace("called zoom on beat event");
					}
					case "zoomBack": 
					{
						camLikeMilf = false;
						camBack = true;

						trace("called zoom backwards on beat event");
					}
					case "zoomNormal": 
					{
						camLikeMilf = false;
						camBack = false;

						trace("called zoom back to normal event");
					}
					case "switchPos": 
					{
						switch (daVal1)
						{
							case 0: 
								switchSide(true);
							case 1: 
								switchSide(false);
						}

						trace("called switch position event");
						
					}
					case "setDefCamZoom": 
					{
						defaultCamZoom = daVal1;
						trace("called change default cam zoom event");
					}
					case "shakeCam": 
					{
						var data = daVal2.split(",");
						switch (daVal1)
						{
							case 0: 
								FlxG.camera.shake(Std.parseFloat(data[0]), Std.parseFloat(data[1]));
							case 1: 
								camHUD.shake(Std.parseFloat(data[0]), Std.parseFloat(data[1]));
						}

						trace("called shake camera event");
					}
					case "hideHUD": 
					{
						var data = daVal2.split(",");
						switch daVal1
						{
							case 0: 
							{
								if (strumVis)
								{
									for (note in playerStrums)
										note.visible = false;
									for (note in cpuStrums)
										note.visible = false;

									strumVis = false;
								}else 
								{
									for (note in playerStrums)
										note.visible = true;
									for (note in cpuStrums)
										note.visible = true;

									strumVis = true;
								}
							}
							case 1: 
							{
								if (healthVis)
								{
									healthBar.visible = false;
									healthBarBG.visible = false;
									iconP1.visible = false;
									iconP2.visible = false;
									scoreTxt.visible = false;
									missText.visible = false;
									grayThingy.visible = false;

									healthVis = false;
								}else 
								{
									healthBar.visible = true;
									healthBarBG.visible = true;
									iconP1.visible = true;
									iconP2.visible = true;
									scoreTxt.visible = true;
									missText.visible = true;
									grayThingy.visible = true;

									healthVis = true;
								}
							}
							case 2: 
							{
								
								FlxTween.tween(camHUD, {alpha: data[0]}, Std.parseFloat(data[1]));
						
							}
						}
					}
					case "camFocus": 
					{
						var data = daVal2.split(",");
						switch daVal1
						{
							case 0: 
							{
								camFollow.setPosition(dad.getMidpoint().x + Std.parseFloat(data[0]), dad.getMidpoint().y + Std.parseFloat(data[1]));
								camForced = true;
							}
							case 1: 
							{
								camFollow.setPosition(boyfriend.getMidpoint().x + Std.parseFloat(data[0]), boyfriend.getMidpoint().y + Std.parseFloat(data[1]));
								camForced = true;
							}
							case 2: 
							{
								camFollow.setPosition(gf.getMidpoint().x + Std.parseFloat(data[0]), gf.getMidpoint().y + Std.parseFloat(data[1]));
								camForced = true;
							}
							case 3: 
							{
								camForced = false;
							}
						}
					}

				}
				SONG.events.remove(event);
			}

			FlxG.watch.addQuick("event plz work", curStep + " / " + daStep);
		}

		//#if debug
		if (FlxG.keys.justPressed.ZERO)
		{
			CoolThings.antialiasing = true;
			trace(CoolThings.antialiasing);
		}
		
		#if SECRET
		lul += 0.01 + FlxG.random.float(-0.02, 0.05);
		
		playerStrums.forEach(function(leNote:StrumNote)
		{
			for (i in 0...3)
			{
				leNote.x += Math.sin(lul + i);
			}
		});
		#end
		
		if (FlxG.keys.pressed.H)
		{
			zoomBack = false;
			camZooming = false;
		}else
		{
			//zoomBack = true;
			//camZooming = true;
		}

		if (FlxG.keys.pressed.G)
		{
			camHUD.alpha = 0;
			noScore = true;

		}else if (FlxG.keys.justReleased.G)
		{
			camHUD.alpha = 1;
			noScore = false;
		}

		if (FlxG.keys.pressed.U)
		{
			camGame.zoom -= 0.005;
			camHUD.zoom -= 0.006;
		}

		if (FlxG.keys.pressed.I)
		{
			camGame.zoom += 0.005;
			camHUD.zoom += 0.006;
		}
		//#end

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		botTxt.visible = CoolThings.botplay;

		#if !debug
		perfectMode = false;
		#end

		/*if (FlxG.keys.justPressed.O)
		{
			CoolThings.botplay = true;
		}*/
		
		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}

		//trace(minutesRemaining + ':' + secondsRemaining);

		if(updateTime) 
		{
			var curTime:Float = Conductor.songPosition - CoolThings.offset;
			if(curTime < 0) curTime = 0;
			songPercent = (curTime / songLength);

			var secondsTotal:Int = Math.floor((songLength - curTime) / 1000);
			if(secondsTotal < 0) secondsTotal = 0;

			var minutesRemaining:Int = Math.floor(secondsTotal / 60);
			var secondsRemaining:String = '' + secondsTotal % 60;
			if(secondsRemaining.length < 2) secondsRemaining = '0' + secondsRemaining; //Dunno how to make it display a zero first in Haxe lol
			timeTxt.text = minutesRemaining + ':' + secondsRemaining;

			//trace(minutesRemaining + ':' + secondsRemaining);
		}

		if (!dad.animation.curAnim.name.startsWith("sing") && !dad.animation.curAnim.name.startsWith("idle") && dad.animation.curAnim.finished)
		{
			noAnimate = false;
			freeAnimation = false;
		}

		if (CoolThings.botplay)
		{
			usedBotplay = true;
		}

		if (usedBotplay)
		{
			songScore = 0;
			accuracy = 0;
		}

		FlxG.watch.addQuick("usedbotplay", usedBotplay);

		switch (curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
		}

		//if (SONG.song.toLowerCase() == "test")
		//	freeAnimation = true;

		super.update(elapsed);

		scoreTxt.text = "Score:" + songScore + " (" + accuracy + "%)";
		missText.text = "Misses:" + misses;

		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			//Conductor.songPosition -= 1000;
			//FlxG.sound.music.time = Conductor.songPosition;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				// gitaroo man easter egg
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		
			#if desktop
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			#end
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			FlxG.switchState(new ChartingState());

			#if desktop
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, CoolUtil.boundTo(1 - (elapsed * 30), 0, 1))));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, CoolUtil.boundTo(1 - (elapsed * 30), 0, 1))));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;

		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new AnimationDebug(SONG.player2));
		#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (zoomBack)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, CoolUtil.boundTo(1 - (elapsed * 4), 0, 1));
			camHUD.zoom = FlxMath.lerp(defaultHUDZoom, camHUD.zoom, CoolUtil.boundTo(1 - (elapsed * 4), 0, 1));
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}
		// better streaming of shit

		// RESET = Quick Game Over Screen
		if (FlxG.keys.justPressed.R)
		{
			health = 0;
			trace("RESET = True");
		}

		// CHEAT = brandon's a pussy
		if (controls.CHEAT)
		{
			health += 1;
			trace("User is cheating!");
		}

		if (FlxG.save.data.practice)
		{
			if (health <= 0)
				health = 0;
		}else
		{
			if (health <= 0)
			{
				boyfriend.stunned = true;

				persistentUpdate = false;
				persistentDraw = false;
				paused = true;

				vocals.stop();
				FlxG.sound.music.stop();

				openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

				// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
			
				#if desktop
				// Game Over doesn't get his own variable because it's only used here
				DiscordClient.changePresence("Game Over - " + detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
				#end
			}
		}

		var roundedSpeed:Float = FlxMath.roundDecimal(SONG.speed, 2);

		if (unspawnNotes[0] != null)
		{
			/*while (unspawnNotes.length > 0 && unspawnNotes[0].strumTime - Conductor.songPosition < 1500 / roundedSpeed)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}*/

			var time:Float = 1500;
			if(roundedSpeed < 1) time /= roundedSpeed;

			while (unspawnNotes.length > 0 && unspawnNotes[0].strumTime - Conductor.songPosition < time)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.insert(0, dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			var fakeCrochet:Float = (60 / SONG.bpm) * 1000;

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.gfNote)
					isGFSection = true;
				else 
					isGFSection = false;

				/*if(!daNote.mustPress && CoolThings.downscroll)
				{
					daNote.active = true;
					daNote.visible = true;
				}
				else if (daNote.y > FlxG.height)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}*/

				// i am so fucking sorry for this if condition

				var strumX:Float = 0;
				var strumY:Float = 0;

				if(daNote.mustPress) 
				{
					strumX = playerStrums.members[daNote.noteData].x;
					strumY = playerStrums.members[daNote.noteData].y;
				} else 
				{
					strumX = cpuStrums.members[daNote.noteData].x;
					strumY = cpuStrums.members[daNote.noteData].y;
				}
				var center:Float = strumY + Note.swagWidth / 2;

				if (CoolThings.downscroll) 
				{
					daNote.y = (strumY + 0.45 * (Conductor.songPosition - daNote.strumTime) * roundedSpeed);

					if (daNote.isSustainNote) 
					{
						//Jesus fuck this took me so much mother fucking time AAAAAAAAAA
						if (daNote.animation.curAnim.name.endsWith('end')) 
						{
							daNote.y += 10.5 * (fakeCrochet / 400) * 1.5 * roundedSpeed + (46 * (roundedSpeed - 1));
							daNote.y -= 46 * (1 - (fakeCrochet / 600)) * roundedSpeed;

							if(isPixelArrows) {
								daNote.y += 8;
							}
						} 

						daNote.y += (Note.swagWidth / 2) - (60.5 * (roundedSpeed - 1));
						daNote.y += 27.5 * ((SONG.bpm / 100) - 1) * (roundedSpeed - 1);

						if(daNote.mustPress || !daNote.ignoreNote)
						{
							if(daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= center
								&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
							{
								var swagRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);
								swagRect.height = (center - daNote.y) / daNote.scale.y;
								swagRect.y = daNote.frameHeight - swagRect.height;

								daNote.clipRect = swagRect;
							}
						}
					}
				} else 
				{
	
					daNote.y = (strumY  - 0.45 * (Conductor.songPosition - daNote.strumTime) * roundedSpeed);

					if(daNote.isSustainNote)
					{
						if (daNote.y + daNote.offset.y * daNote.scale.y <= center
							&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
						{
							var swagRect = new FlxRect(0, strumLine.y + Note.swagWidth / 2 - daNote.y, daNote.width * 2, daNote.height * 2);
							swagRect.y = (center - daNote.y) / daNote.scale.y;
							swagRect.height -= swagRect.y;
		
							daNote.clipRect = swagRect;
						}
					}
				}

				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					if (SONG.song.toLowerCase() != 'tutorial')
					{
						camZooming = true;
						zoomBack = true;
					}

					cpuNoteHit(daNote);
				}

				if(daNote.mustPress && CoolThings.botplay) 
				{
					if (daNote.noteType != 3)
					{
						if(daNote.isSustainNote) 
						{
							if(daNote.canBeHit) 
							{
								goodNoteHit(daNote);
							}
			
						} else if (daNote.strumTime <= Conductor.songPosition) 
						{
							goodNoteHit(daNote);
						}
					}
				}

				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));

				var killNote:Bool = daNote.y < -daNote.height;
				if(CoolThings.downscroll) 
				{
					killNote = daNote.y > FlxG.height;
				}

				if (killNote)
				{
					if (daNote.mustPress && !CoolThings.botplay && !endingSong)
					{
						if (daNote.tooLate || !daNote.wasGoodHit)
						{
							
							//Dupe note remove
							notes.forEachAlive(function(note:Note) 
							{
								if (daNote != note && daNote.mustPress && daNote.noteData == note.noteData && daNote.isSustainNote == note.isSustainNote && Math.abs(daNote.strumTime - note.strumTime) < 10) 
								{
									note.kill();
									notes.remove(note, true);
									note.destroy();
								}
							});

							if (daNote.noteType != 3)
								noteMiss(daNote);
						}
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
		}


		cpuStrums.forEach(function(spr:StrumNote)
		{
			if (spr.animation.finished)
			{
				spr.playAnim('static');
				spr.centerOffsets();
			}
		});

		if (CoolThings.botplay)
		{
			playerStrums.forEach(function(spr:StrumNote)
			{
				if (spr.animation.finished)
				{
					spr.playAnim('static');
					spr.centerOffsets();
				}
			});
		}

		if (!inCutscene)
		{
			if (!CoolThings.botplay)
				keyShit();

			if (boyfriend.holdTimer > Conductor.stepCrochet * 0.001 * 4 && boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
			{
				boyfriend.playAnim("idle");
				camDisplaceX = 0;
				camDisplaceY = 0;
			}
			
		}


		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
	}

	function moveCameraSection(?id:Int = 0):Void
	{
		if(SONG.notes[id] == null) return;

		if (SONG.notes[id].gfSection)
		{
			camFollow.setPosition(gf.getMidpoint().x, gf.getMidpoint().y - 100);
			//tweenCamIn();
			return;
		}

		if (!SONG.notes[id].mustHitSection)
		{
			moveCamera(true);
		}
		else
		{
			moveCamera(false);
		}
	}

	public function moveCamera(isDad:Bool)
	{
		if(isDad)
		{
			camFollow.setPosition(dad.getMidpoint().x + 150 + camDisplaceX, dad.getMidpoint().y - 100 + camDisplaceY);
					
			switch (dad.curCharacter)
			{
				case 'mom':
					camFollow.y = dad.getMidpoint().y;
				case 'senpai':
					camFollow.y = dad.getMidpoint().y - 430 + camDisplaceY;
					camFollow.x = dad.getMidpoint().x - 100 + camDisplaceX;
				case 'senpai-angry':
					camFollow.y = dad.getMidpoint().y - 430 + camDisplaceY;
					camFollow.x = dad.getMidpoint().x - 100 + camDisplaceX;
				case 'sonic.exe alt': 
					camFollow.y = dad.getMidpoint().y - 430 + camDisplaceY;
					camFollow.x = dad.getMidpoint().x - 100 + camDisplaceX;
				case "gf": 
					tweenCamIn();
			}
		}else 
		{
			camFollow.setPosition(boyfriend.getMidpoint().x - 100 + camDisplaceX, boyfriend.getMidpoint().y - 100 + camDisplaceY);

			if (SONG.song.toLowerCase() == "tutorial")
				FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});

			switch (curStage)
			{
				case 'limo':
					camFollow.x = boyfriend.getMidpoint().x - 300 + camDisplaceX;
				case 'mall':
					camFollow.y = boyfriend.getMidpoint().y - 200 + camDisplaceY;
				case 'school':
					camFollow.x = boyfriend.getMidpoint().x - 200 + camDisplaceX;
					camFollow.y = boyfriend.getMidpoint().y - 200 + camDisplaceY;
				case 'schoolEvil':
					camFollow.x = boyfriend.getMidpoint().x - 200 + camDisplaceX;
					camFollow.y = boyfriend.getMidpoint().y - 200 + camDisplaceY;
			}

			switch (boyfriend.curCharacter) 
			{
				case 'bfTT':
					camFollow.y = boyfriend.getMidpoint().y - 250 + camDisplaceY;
					camFollow.x = boyfriend.getMidpoint().x - 300 + camDisplaceX;
			}
		}
	}

	function endSong():Void
	{
		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			#if !switch
			Highscore.saveScore(SONG.song, songScore, storyDifficulty);
			#end
		}

		freeplayShit = true;

		if (isStoryMode)
		{
			campaignScore += songScore;

			storyPlaylist.remove(storyPlaylist[0]);

			if (storyPlaylist.length <= 0)
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'));

				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;

				FlxG.switchState(new StoryMenuState());

				// if ()
				StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

				if (SONG.validScore)
				{
					NGio.unlockMedal(60961);
					Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
				}

				FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
				FlxG.save.flush();
			}
			else
			{
				var difficulty:String = "";

				if (storyDifficulty == 0)
					difficulty = '-easy';

				if (storyDifficulty == 2)
					difficulty = '-hard';

				trace('LOADING NEXT SONG');
				trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

				if (SONG.song.toLowerCase() == 'eggnog')
				{
					var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
						-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
					blackShit.scrollFactor.set();
					add(blackShit);
					camHUD.visible = false;

					FlxG.sound.play(Paths.sound('Lights_Shut_off'));
				}

				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				prevCamFollow = camFollow;
				var video:MP4Handler = new MP4Handler();

				PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
				FlxG.sound.music.stop();

				if (SONG.song.toLowerCase() == "guns")
				{
					video.playMP4(Paths.video('gunsCutscene'), new PlayState(), false, false, false);
				}else if (SONG.song.toLowerCase() == "stress")
				{
					video.playMP4(Paths.video('stressCutscene'), new PlayState(), false, false, false);
				}else 
				{
					trace("bruh");
					LoadingState.loadAndSwitchState(new PlayState());
				}
			}
		}
		else
		{
			trace('WENT BACK TO FREEPLAY??');
			//FlxG.sound.playMusic(Paths.music('freakyMenu'));
			FlxG.switchState(new FreeplayState());
		}

	}

	var endingSong:Bool = false;

	private function popUpScore(strumtime:Float, daNote:Note):Void
	{
		if (!noScore)
		{
			var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
			// boyfriend.playAnim('hey');
			vocals.volume = 1;

			var placement:String = Std.string(combo);

			var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
			coolText.screenCenter();
			coolText.x = FlxG.width * 0.55;
			//

			var rating:FlxSprite = new FlxSprite();
			var score:Int = 350;

			var daRating:String = "sick";

			if (noteDiff > Conductor.safeZoneOffset * 0.75)
			{
				daRating = 'shit';
				misses ++;
				score = 50;
			}
			else if (noteDiff > Conductor.safeZoneOffset * 0.5)
			{
				daRating = 'bad';
				score = 100;
			}
			else if (noteDiff > Conductor.safeZoneOffset * 0.25) 
			{
				daRating = 'good';
				score = 200;
			}

			if(daRating == 'sick')
			{
				if (CoolThings.doSplash)
					makeSplash(daNote);
			}

			noteHits++;
			songScore += score;

			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			*/

			//var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';

			if (isPixelArrows)
			{
				//pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}

			rating.loadGraphic(Paths.image("UI/" + daRating + pixelShitPart2));
			rating.screenCenter();
			rating.x = coolText.x - 40 - 200;
			rating.y += 40;
			rating.acceleration.y = 550;
			rating.scrollFactor.set(0.3, 0.3);
			rating.scale.set(0.55, 0.55);
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);

			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image('UI/combo' + pixelShitPart2));
			comboSpr.screenCenter();
			comboSpr.x = coolText.x - 15 - 200;
			comboSpr.y += 100;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;
			comboSpr.scale.set(0.75, 0.75);
			comboSpr.scrollFactor.set(0.3, 0.3);

			comboSpr.velocity.x += FlxG.random.int(1, 10);
			add(rating);

			//rating.cameras = [camHUD];
			//comboSpr.cameras = [camHUD];

			if (!isPixelArrows)
			{
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				rating.antialiasing = CoolThings.antialiasing;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = CoolThings.antialiasing;
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}

			comboSpr.updateHitbox();
			rating.updateHitbox();

			var seperatedScore:Array<Int> = [];
			var comboSplit:Array<String> = (combo + "").split('');

			if (comboSplit.length == 1)
			{
				seperatedScore.push(0);
				seperatedScore.push(0);
			}
			else if (comboSplit.length == 2)
				seperatedScore.push(0);

			for (i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}

			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image('num' + Std.int(i) + pixelShitPart2));
				numScore.screenCenter();
				numScore.x = coolText.x + (43 * daLoop) - 290;
				numScore.y += 180;
				numScore.scale.set(0.55, 0.55);
				numScore.scrollFactor.set(0.3, 0.3);
				//numScore.cameras = [camHUD];

				if (!isPixelArrows)
				{
					numScore.antialiasing = CoolThings.antialiasing;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				numScore.updateHitbox();

				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);

				if (combo >= 10 || combo == 0)
				{
					add(numScore);
				}

				if (combo >=10)
					add(comboSpr);


				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});

				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			*/

			coolText.text = Std.string(seperatedScore);
			// add(coolText);

			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();

					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});

			curSection += 1;
		}
	}

	function makeSplash(daNote:Note):Void
	{
		var recycledNote = grpNoteSplashes.recycle(NoteSplash);
		recycledNote.setupNoteSplash(daNote.x, strumLine.y, daNote.noteData);
		recycledNote.antialiasing = CoolThings.antialiasing;
		grpNoteSplashes.add(recycledNote);
	}

	private function keyShit():Void // I've invested in emma stocks
	{

			// control arrays, order L D R U
			var holdArray:Array<Bool> = [
				controls.LEFT, 
				controls.DOWN, 
				controls.UP, 
				controls.RIGHT
			];

			var pressArray:Array<Bool> = [
				controls.LEFT_P,
				controls.DOWN_P,
				controls.UP_P,
				controls.RIGHT_P
			];

			var releaseArray:Array<Bool> = [
				controls.LEFT_R,
				controls.DOWN_R,
				controls.UP_R,
				controls.RIGHT_R
			];
	 
			
			
			// HOLDS, check for sustain notes
			if (holdArray.contains(true) && !boyfriend.stunned &&  generatedMusic)
			{
				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
						goodNoteHit(daNote);
				});
			}

	 
			// PRESSES, check for note hits
			if (pressArray.contains(true)/* && !boyfriend.stunned*/ &&  generatedMusic)
			{
				boyfriend.holdTimer = 0;
	 
				var possibleNotes:Array<Note> = []; // notes that can be hit
				var directionList:Array<Int> = []; // directions that can be hit
				var dumbNotes:Array<Note> = []; // notes to kill later
				//var daNote = possibleNotes[0];
	 
				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
					{
						if (directionList.contains(daNote.noteData))
						{
							for (coolNote in possibleNotes)
							{
								if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
								{ // if it's the same note twice at < 10ms distance, just delete it
									// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
									dumbNotes.push(daNote);
									break;
								}
								else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
								{ // if daNote is earlier than existing note (coolNote), replace
									possibleNotes.remove(coolNote);
									possibleNotes.push(daNote);
									break;
								}
							}
						}
						else
						{
							possibleNotes.push(daNote);
							directionList.push(daNote.noteData);
						}
					}
				});
	 
				for (note in dumbNotes)
				{
					//FlxG.log.add("killing dumb ass note at " + note.strumTime);
					note.kill();
					notes.remove(note, true);
					note.destroy();
				}
	 
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
	 
				var dontCheck = false;

				for (i in 0...pressArray.length)
				{
					if (pressArray[i] && !directionList.contains(i))
						dontCheck = true;
				}

				if (perfectMode)
					goodNoteHit(possibleNotes[0]);

				else if (possibleNotes.length > 0 && !dontCheck)
				{
					if (!CoolThings.ghost)
					{
						for (shit in 0...pressArray.length)
						{ // if a direction is hit that shouldn't be
							if (pressArray[shit] && !directionList.contains(shit))
							{
								noteMiss(shit);
							}
						}
					}
					for (coolNote in possibleNotes)
					{
						if (pressArray[coolNote.noteData])
						{
							if (mashViolations != 0)
								mashViolations--;
							goodNoteHit(coolNote);
						}
					}
				}
				else if (!CoolThings.ghost)
				{
					for (shit in 0...pressArray.length)
						if (pressArray[shit])
						{
							noteMiss(shit);
						}
				}

				if (dontCheck && possibleNotes.length > 0 && CoolThings.ghost && !CoolThings.botplay)
				{
					if (mashViolations > 4)
					{
						health -= 0.15;
						//misses++;
					}else 
					{
						mashViolations++;
					}
				}


			}
			
			notes.forEachAlive(function(daNote:Note)
			{
				if(CoolThings.downscroll && daNote.y > strumLine.y ||
				!CoolThings.downscroll && daNote.y < strumLine.y)
				{
					// Force good note hit regardless if it's too late to hit it or not as a fail safe
					if(CoolThings.botplay && daNote.canBeHit && daNote.mustPress ||
					CoolThings.botplay && daNote.tooLate && daNote.mustPress)
					{
						if (daNote.noteType != 3)
						{
							goodNoteHit(daNote);
							boyfriend.holdTimer = daNote.sustainLength;
						}
						
					}
				}
			});
	 
			if (!CoolThings.botplay)
			{
				playerStrums.forEach(function(spr:StrumNote)
				{

					if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
					{
						spr.playAnim('pressed');
						spr.resetAnim = 0;
					}
					if (!holdArray[spr.ID])
					{
						spr.playAnim('static');
						spr.resetAnim = 0;
					}	 
					if (spr.animation.curAnim.name == 'confirm' && !isPixelArrows)
					{
						spr.centerOffsets();
						spr.offset.x -= 13;
						spr.offset.y -= 13;
					}
					else
						spr.centerOffsets();
				});
			}
	}


	function noteMiss(?daNote:Note, ?direction:Int):Void
	{
		health -= 0.0475;

		if (combo > 5 && gf.animOffsets.exists('sad'))
		{
			gf.playAnim('sad');
		}

		combo = 0;
		songScore -= 10;

		misses++;

		vocals.volume = 0;

		FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));

		boyfriend.stunned = true;

		new FlxTimer().start(5 / 60, function(tmr:FlxTimer)
		{
			boyfriend.stunned = false;
		});

		if (direction != null)
		{
			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
				
			}

		}else 
		{
			switch (daNote.noteType)
			{
				case 3: 
					//do nothing L
				case 2: 
				{
					health -= 0.4;

					switch (daNote.noteData % 4)
					{
						case 0:
							boyfriend.playAnim('singLEFTmiss', true);
						case 1:
							boyfriend.playAnim('singDOWNmiss', true);
						case 2:
							boyfriend.playAnim('singUPmiss', true);
						case 3:
							boyfriend.playAnim('singRIGHTmiss', true);
					}
				}
				default: 
				{

					switch (daNote.noteData % 4)
					{
						case 0:
							boyfriend.playAnim('singLEFTmiss', true);
						case 1:
							boyfriend.playAnim('singDOWNmiss', true);
						case 2:
							boyfriend.playAnim('singUPmiss', true);
						case 3:
							boyfriend.playAnim('singRIGHTmiss', true);
						
					}
				}
			}
		}
	}

	function badNoteCheck()
	{
		// just double pasting this shit cuz fuk u
		// REDO THIS SYSTEM!
		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		if (oldInput)
		{
			if (leftP)
			{
				misses ++;
				noteMiss(0);
			}
			if (downP)
			{
				misses ++;
				noteMiss(1);
			}
			if (upP)
			{
				misses ++;
				noteMiss(2);
			}
			if (rightP)
			{
				misses ++;
				noteMiss(3);
			}
		}
		
	}
	

	function noteCheck(keyP:Bool, note:Note):Void
	{
		if (keyP)
			goodNoteHit(note);
		else if (!theFunne)
		{
			badNoteCheck();
			//goodNoteHit(note);
		}
	}

	function goodNoteHit(note:Note, resetMashViolation = true):Void
	{
		if (!CoolThings.botplay)
			if (note.noteType == 3)
			{
				health -= 0.4;
			}

		if (mashing != 0)
			mashing = 0;

		if (!resetMashViolation && mashViolations >= 1)
			mashViolations--;

		if (mashViolations < 0)
			mashViolations = 0;

		if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
				popUpScore(note.strumTime, note);
				combo += 1;
			}

			if (note.noteData >= 0)
				health += 0.023;
			else
				health += 0.004;
				
			var animToPlay:String = '';
			switch (note.noteData)
			{
				case 2:
					animToPlay = 'singUP';
					camDisplaceY = -20;
					camDisplaceX = 0;
				case 3:
					animToPlay = 'singRIGHT';
					camDisplaceX = 20;
					camDisplaceY = 0;
				case 1:
					animToPlay = 'singDOWN';
					camDisplaceY = 20;
					camDisplaceX = 0;
				case 0:
					animToPlay = 'singLEFT';
					camDisplaceX = -20;
					camDisplaceY = 0;
			}


			if (note.gfNote)
			{
				gf.playAnim(animToPlay, true);
				gf.holdTimer = 0;
			}else 
			{
				boyfriend.playAnim(animToPlay, true);
				boyfriend.holdTimer = 0;
			}

					

			playerStrums.forEach(function(spr:StrumNote)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.playAnim('confirm', true);
				}
				if (spr.animation.curAnim.name == 'confirm' && !isPixelArrows)
				{
					spr.centerOffsets();
					spr.offset.x -= 13;
					spr.offset.y -= 13;
				}
				else
					spr.centerOffsets();
			});
	
			note.wasGoodHit = true;
			vocals.volume = 1;
	
			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}		
		}
	}

	function cpuNoteHit(note:Note):Void
	{		
		var isAlt:Bool = false;

					
		var altAnim:String = "";

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].altAnim) {
				altAnim = '-alt';
				isAlt = true;
			}
		}

		var animToPlay:String = '';
		switch (Math.abs(note.noteData))
		{
			case 0:
				animToPlay = 'singLEFT';
				camDisplaceX = -20;
				camDisplaceY = 0;
			case 1:
				animToPlay = 'singDOWN';
				camDisplaceY = 20;
				camDisplaceX = 0;
			case 2:
				animToPlay = 'singUP';
				camDisplaceY = -20;
				camDisplaceX = 0;
			case 3:
				animToPlay = 'singRIGHT';
				camDisplaceX = 20;
				camDisplaceY = 0;
		}

		if (note.gfNote || note.noteType == 1)
		{
			if (!noAnimate)
				gf.playAnim(animToPlay + altAnim, true);
			gf.holdTimer = 0;
		}else 
		{
			if (!noAnimate)
				dad.playAnim(animToPlay + altAnim, true);
			dad.holdTimer = 0;
		}

					

		cpuStrums.forEach(function(spr:StrumNote)
		{
			if (Math.abs(note.noteData) == spr.ID)
			{
				spr.playAnim('confirm', true);
			}
			if (spr.animation.curAnim.name == 'confirm' && !isPixelArrows)
			{
				spr.centerOffsets();
				spr.offset.x -= 13;
				spr.offset.y -= 13;
			}
			else
				spr.centerOffsets();
		});
	
		note.wasGoodHit = true;
		vocals.volume = 1;
	
		if (!note.isSustainNote)
		{
			note.kill();
			notes.remove(note, true);
			note.destroy();
		}
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive()
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	/*function spawnNoteSplashOnNote(note:Note) 
	{
		if(note != null) 
		{
			var strum = playerStrums.members[note.noteData];
			if(strum != null) 
			{
				spawnNoteSplash(strum.x, strum.y, note.noteData);
			}
		}
	}*/
	function spawnNoteSplashOnNote(note:Note) {
		notes.forEachAlive(function(daNote:Note)
		{
			spawnNoteSplash(note.x, note.y, note.noteData);
		});
		/*var strum = playerStrums.members[note.noteData];
		if(strum != null) {
		spawnNoteSplash(strum.x, strum.y, note.noteData);
		}*/
	}

	public function spawnNoteSplash(x:Float, y:Float, data:Int) {
		var splash:NoteSplash = grpNoteSplashes.recycle(NoteSplash);
		splash.setupNoteSplash(x, y, data);
		grpNoteSplashes.add(splash);
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	function switchSide(yes:Bool)
	{
		var xPos1 = dad.x;
		var xPos2 = boyfriend.x;
		if (yes)
		{
			dad.x = xPos2;
			boyfriend.x = xPos1;
			dad.flipX = true;
			boyfriend.flipX = true;
			FlxG.camera.zoom += 5;
			defaultCamZoom == 1.1;
		}else 
		{
			dad.x = xPos2;
			dad.flipX = false;
			boyfriend.x = xPos1;
			boyfriend.flipX = false;
			FlxG.camera.zoom += 5;
			defaultCamZoom = 0.9;
		}

	}

	function switchBack()
	{
		dad.x = 100;
		dad.flipX = false;
		boyfriend.x = 750;
		boyfriend.flipX = false;
		FlxG.camera.zoom += 5;
		defaultCamZoom = 0.9;
	}

	function switchCharacter(player:String, switchTo:String)
	{
		var daX:Float;
		var daY:Float;
		if (player == "dad" || player == "1")
		{
			daX = dad.x;
			daY = dad.y;
			remove(dad);
			dad = new Character(daX, daY, switchTo);
			add(dad);
		}else if (player == "bf" || player == "2")
		{
			daX = boyfriend.x;
			daY = boyfriend.y;
			remove(boyfriend);
			boyfriend = new Boyfriend(daX, daY, switchTo);
			add(boyfriend);
		}else if (player == "gf" || player == "3")
		{
			daX = gf.x;
			daY = gf.y;
			remove(gf);
			gf = new Character(daX, daY, switchTo);
			add(gf);
		}
	}

	override function stepHit()
	{
		super.stepHit();

		if (dad.curCharacter == 'sonicfun' && SONG.song.toLowerCase() == 'endless')
		{
			if (spinArray.contains(curStep))
			{
				strumLineNotes.forEach(function(tospin:FlxSprite)
				{
					FlxTween.angle(tospin, 0, 360, 0.2, {ease: FlxEase.quintOut});
				});
			}
		}

		if (SONG.song == "bb" && curStep == 20)
		{
			boyfriend.setPosition(850, 570);
		}

		if (curSong == 'you-cant-run')
		{
			if (curStep == 528) // PIXEL MOMENT LAWLALWALAWL
			{
				healthBar.createFilledBar(FlxColor.fromRGB(0, 128, 7), FlxColor.fromRGB(49, 176, 209));
				SONG.arrows = 'pixel';
				isPixelArrows = true;
				playerStrums.forEachAlive(function(daArrow:StrumNote)
				{
					daArrow.kill();
				});
				cpuStrums.forEachAlive(function(daArrow:StrumNote)
				{
					daArrow.kill();
				});
				generateStaticArrows(0);
				generateStaticArrows(1);
				switchCharacter("dad", "sonic.exe alt");
				dad.setPosition(100, 350);
				remove(gf);
				switchCharacter("bf", "bf-pixel");
				boyfriend.setPosition(630, 370);
				bgspec.visible = true;
			}
			else if (curStep == 784) // BACK TO NORMAL MF!!!
			{
				healthBar.createFilledBar(FlxColor.fromRGB(0, 19, 102), FlxColor.fromRGB(49, 176, 209));
				SONG.arrows = 'default';
				isPixelArrows = false;
				playerStrums.forEachAlive(function(daArrow:StrumNote)
				{
					daArrow.kill();
				});
				cpuStrums.forEachAlive(function(daArrow:StrumNote)
				{
					daArrow.kill();
				});
				generateStaticArrows(0);
				generateStaticArrows(1);
				switchCharacter("dad", "sonic.exe");
				dad.setPosition(116 -20, 107);
				dad.y -= 125;
				switchCharacter("bf", "bf");
				boyfriend.setPosition(1036 - 100, 300);
				dad.scrollFactor.set(1.3, 1);
				boyfriend.scrollFactor.set(1.3, 1);
				bgspec.visible = false;
			}

		}

		if (curSong == "triple-trouble")
		{
			switch (curStep)
			{
				case 1040 | 2320 | 4111: 
					dad.setPosition(20 - 200, -94.75 + 100);
					boyfriend.setPosition(502.45 + 200, 370.45);
				case 1296: 
					boyfriend.setPosition(770, 450);
					dad.setPosition(100, 400);
				case 2823: 
					dad.setPosition(20 - 200, 30 + 200);
					switchCharacter("bf", "bf");
					boyfriend.setPosition(770, 450);
			}
		}
		if (SONG.song.toLowerCase() == "megalo-strike-back")
		{
			switch (curStep)
			{
				case 703:
					noScore = true;
				case 832: 
					noScore = false;
				case 2020: 
					dad.playAnim('zrick', true);
					freeAnimation = true;
				case 2051: 
					noScore = true;
				case 2080:
					freeAnimation = false;
				case 2085: 
					defaultCamZoom = 0.9;
				case 2276:
					noScore = false;
			}
			
		}


		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		if(SONG.song.toLowerCase() == 'stress')
		{
			//RIGHT
			for (i in 0 ...picoStep.right.length)
			{
				if (curStep == picoStep.right[i])
				{
					gf.playAnim('shoot' + FlxG.random.int(1, 2), true);
					//var tankmanRunner:TankmenBG = new TankmenBG();
				}
			}
			//LEFT
			for (i in 0...picoStep.left.length)
			{
				if (curStep == picoStep.left[i])
				{
					gf.playAnim('shoot' + FlxG.random.int(3, 4), true);
				}
			}
			
			//Left tankspawn
			/*for (i in 0...tankStep.left.length)
			{
				if (curStep == tankStep.left[i]){
					var tankmanRunner:TankmenBG = new TankmenBG();
					tankmanRunner.resetShit(FlxG.random.int(630, 730) * -1, 255, true, 1, 1.5);

					tankmanRun.add(tankmanRunner);
				}
			}

			//Right spawn
			for(i in 0...tankStep.right.length)
			{
				if (curStep == tankStep.right[i]){
					var tankmanRunner:TankmenBG = new TankmenBG();
					tankmanRunner.resetShit(FlxG.random.int(1500, 1700) * 1, 275, false, 1, 1.5);
					tankmanRun.add(tankmanRunner);
				}
			}*/

			/*if (curStep % 8 == FlxG.random.int(2, 4))
				gf.playAnim('shoot' + FlxG.random.int(3, 4), true);

			if (curStep % 8 == 4)
				gf.playAnim('shoot' + FlxG.random.int(3, 4), true);

			if (curStep % 12 == FlxG.random.int(4, 8))
				gf.playAnim('shoot' + FlxG.random.int(1, 2), true);*/

			//if (curStep % 4 == 2)
				//gf.playAnim('shoot' + FlxG.random.int(1, 2), true);
		}

		if (dad.curCharacter == 'tankman' && SONG.song.toLowerCase() == 'ugh')
		{
			if (curStep == 59 || curStep == 443 || curStep == 523 || curStep == 827)
			{
				dad.addOffset("singUP", 45, 0);
				
				dad.animation.getByName('singUP').frames = dad.animation.getByName('ughAnim').frames;
			}
			if (curStep == 64 || curStep == 448 || curStep == 528 || curStep == 832)
			{
				dad.addOffset("singUP", 24, 56);
				dad.animation.getByName('singUP').frames = dad.animation.getByName('oldSingUP').frames;
			}
		}
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (SONG.song.toLowerCase() == "onslaught" && curBeat >= 96 && curBeat < 128)
		{
			for (note in playerStrums)
			{
				note.visible = false;
			}
			for (note in cpuStrums)
			{
				note.visible = false;
			}
		}else 
		{
			for (note in playerStrums)
			{
				note.visible = true;
			}
			for (note in cpuStrums)
			{
				note.visible = true;
			}
		}

		

		var toogusBeats = [94, 95, 96, 98, 100, 102, 104, 106, 107, 109, 112, 114, 116, 118, 120, 122, 124, 126, 128, 130, 132, 134, 136, 138, 140, 142, 144, 146, 148, 150, 152, 154, 156, 158, 192, 194, 196, 198, 200, 202, 204, 206, 208, 210, 212, 214, 216, 218, 220, 222, 288, 296, 304, 312, 318, 319, 320, 322, 324, 326, 328, 330, 332, 334, 336, 338, 340, 342, 344, 346, 348, 350, 352, 354, 356, 358, 360, 362, 364, 366, 368, 370, 372, 374, 376, 378, 380, 382];
		var _b = 0;

		/*if (SONG.song.toLowerCase() == "sussus-toogus" && curBeat % 4 == 0 && curBeat >= 96 && curBeat < 160)
			flashRed();
		else if (curBeat >= 192 && curBeat < 224)
			flashRed();*/

		if(curSong == 'Sussus-Toogus') // toogus flashes
			{
				while(_b < toogusBeats.length) {
					var meltflash = toogusBeats[_b];
					++_b;
					if(curBeat == meltflash)
					{
						flashRed();
					}
				}
			}

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, CoolThings.downscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING);
		}

		//if (isStoryMode && curBeat == 1)
		//	spawnSongName();

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}

			/*if (!freeAnimation)
			{
				// Dad doesnt interupt his own notes
				if (dad.curCharacter == "spooky")
					if (SONG.notes[Math.floor(curStep / 16)].mustHitSection)
						dad.dance();

				if ((SONG.notes[Math.floor(curStep / 16)].mustHitSection || !dad.animation.curAnim.name.startsWith("sing")) && dad.curCharacter != 'gf' && dad.curCharacter != "spooky")
					{
						dad.dance();
					}
			}*/
		}

		if(curBeat % 2 == 0) 
		{
			if (boyfriend.animation.curAnim.name != null && !boyfriend.animation.curAnim.name.startsWith("sing"))
			{
				boyfriend.dance();
			}
			

		}

		if (dad.animation.curAnim.name != null && !dad.animation.curAnim.name.startsWith("sing"))
		{
			if (dad.curCharacter == "spooky")
			{
				if (curBeat % 1 == 0)
					if (!freeAnimation)
						dad.dance();
			}else 
			{
				if (curBeat % 2 == 0)
					if (!freeAnimation)
						dad.dance();
			}
		}

		if (curSong == 'Tutorial' && dad.curCharacter == 'gf') 
		{
			if (curBeat % 2 == 0 && dad.animOffsets.exists('danceLeft'))
				dad.playAnim('danceLeft');
			if (curBeat % 2 == 1 && dad.animOffsets.exists('danceRight'))
				dad.playAnim('danceRight');
		}


		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		if (curStage == 'sonicfunStage')
		{
			funpillarts1ANIM.animation.play('bumpypillar', true);
			funpillarts2ANIM.animation.play('bumpypillar', true);
			funboppers1ANIM.animation.play('bumpypillar', true);
			funboppers2ANIM.animation.play('bumpypillar', true);
		}

		if (curStage == 'tankStage')
		{
			tank0.animation.play("bop");
			tank1.animation.play("bop");
			tank2.animation.play("bop");
			tank3.animation.play("bop");
			tank4.animation.play("bop");
			tank5.animation.play("bop");
			tower.animation.play('bop');
		}

		if (SONG.song.toLowerCase() == 'endless')
		{
			switch (curBeat)
			{
				case 222: 
					defaultCamZoom += 0.14;
					defaultHUDZoom = 6;
					camHUD.alpha = 0;
				case 223: 
					defaultCamZoom += 0.14;
				case 224: 
					defaultCamZoom += 0.14;
					camHUD.alpha = 1;
					defaultHUDZoom = 1;
				case 225: 
					defaultCamZoom = 0.9;
			}
		}

		if (camLikeMilf)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}else if(camBack)
		{
			camGame.zoom -= 0.015;
			camHUD.zoom -= 0.040;
			camZooming = false;
		}

		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (curSong.toLowerCase() == 'onslaught' && curBeat >= 0 && curBeat < 64 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.025;
		}

		if (curSong.toLowerCase() == 'onslaught' && curBeat >= 128 && curBeat < 352 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.025;
		}

		if (curSong.toLowerCase() == 'endless' && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.025;
		}

		if (SONG.song.toLowerCase() == "tutorial")
		{
			zoomBack = false;
			camZooming = false;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			if (SONG.song.toLowerCase() == "ballistic")
			{
				FlxG.camera.zoom += 0.030;
				camHUD.zoom += 0.055;
				camHUD.shake(0.005, 0.2);
			}else
			{
				//STANDARD CAM ZOOMING
				FlxG.camera.zoom += 0.020;
				camHUD.zoom += 0.04;
			}
		}


		iconP1.setGraphicSize(Std.int(iconP1.width + 40));
		iconP2.setGraphicSize(Std.int(iconP2.width + 40));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		

		/*if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			boyfriend.playAnim('idle');
		}*/

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
		}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
		{
			boyfriend.playAnim('hey', true);
			dad.playAnim('cheer', true);
		}

		switch (curStage)
		{
			case 'school':
				bgGirls.dance();

			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);

			case 'limo':
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}
	}

	var curLight:Int = 0;

}

//picoshoot
typedef Ps = 
{
	var right:Array<Int>;
	var left:Array<Int>;
}

/*//tank spawns
typedef Ts = 
{
	var right:Array<Int>;
	var left:Array<Int>;
}*/
