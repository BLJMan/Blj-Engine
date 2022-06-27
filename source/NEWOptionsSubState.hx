package;

import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.graphics.FlxGraphic;
import lime.app.Application;
import flixel.util.FlxSave;
import Controls.KeyboardScheme;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

class NEWOptionsSubState extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;

	var offsetText:FlxText;
	var fpsText:FlxText;

	var controlsStrings:Array<String> = [];

	var descriptionStrings:Array<String> = [
		"change the fps",
		"when ON, lets you press a key whe you're not supposed to",
		"toggle between upscroll and downscroll",
		"toggle middlescroll",
		"botplay",
		"show the miss counter",
		"show the song time",
		"toggle antialiasing",
		"???",
		"toggle between old and new note splashes",
		"toggle note splashes",
		"persistent cached data. WARNING (VERY) HIGH RAM USAGE",
		"dispalce the camera in the direction of the note you hit",
		"light up cpu strums when the opponent hits a note"
	];

	var acceptInput:Bool;

	private var grpControls:FlxTypedGroup<Alphabet>;
	var versionShit:FlxText;

	var shitText:FlxText;

	var camFollow:FlxObject;

	var camFollowThing:FlxObject;

	override function create()
	{

		FlxG.camera.zoom -= 1;

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		controlsStrings = CoolUtil.coolStringFile(
			"change FPS" + "\n" + 
			(CoolThings.ghost ? 'ghost tapping' : 'no ghost tapping') + "\n" + 
			(CoolThings.downscroll ? 'Downscroll' : 'Upscroll') + "\n" + 
			(CoolThings.middlescroll ? 'middlescroll' : 'middlescroll off') + "\n" + 
			(CoolThings.botplay ? 'Botplay on' : 'Botplay off') + "\n" + 
			(CoolThings.showMiss ? 'Show Miss Counter' : 'Hide Miss Counter') + "\n" + 
			(CoolThings.showtime ? 'Show song time' : 'Hide song time') + "\n" +
			(CoolThings.antialiasing ? 'antialiasing' : 'no antialiasing') + "\n" + 
			(CoolThings.secretShh ? 'super secret pause menu ON' : 'super secret pause menu OFF') + "\n" +
			(CoolThings.newSplash ? 'new splash' : 'old splash') + "\n" +
			(CoolThings.doSplash ? 'note splash on' : 'note splash off') + "\n" +
			(CoolThings.persist ? 'Persistent Cached Data ON' : 'Persistent Cached Data OFF') + "\n" + 
			(CoolThings.displaceCam ? "displace camera" : "do not displace camera") + "\n" +
			(CoolThings.cpuStrums ? "light up cpu strums" : "cpu strums stay static"));
		
		trace(controlsStrings);

		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.scrollFactor.set();
		menuBG.antialiasing = CoolThings.antialiasing;
		add(menuBG);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		var textBG:FlxSprite = new FlxSprite(0, 660);
		textBG.makeGraphic(450, 200, FlxColor.BLACK);
		textBG.alpha = 0.55;
		textBG.scrollFactor.set();
		add(textBG);

		offsetText = new FlxText(50, 672, 0, "(Left, Right) | OFFSET: " + FlxG.save.data.offset, 10);
		offsetText.scrollFactor.set();
		offsetText.scale.set(1.4, 1.4);
		offsetText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(offsetText);

		#if desktop
		fpsText = new FlxText(55, 695, 0, "FPS: " + CoolThings.framerate, 10);
		fpsText.scrollFactor.set();
		fpsText.scale.set(1.4, 1.4);
		fpsText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(fpsText);
		#else
		fpsText = new FlxText(50, 695, 0, "lol", 10);
		fpsText.scrollFactor.set();
		fpsText.scale.set(1.4, 1.4);
		fpsText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		fpsText.visible = false;
		add(fpsText);
		#end

		for (i in 0...controlsStrings.length)
		{
			var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, controlsStrings[i], true, false);
			//var controlLabel = new MenuOptionItem((70 * i) - 50, i, controlsStrings, i);
			controlLabel.isMenuItem = true;
			controlLabel.targetY = i;
            controlLabel.screenCenter(X);
			var scr:Float = (controlsStrings.length - 6) * 0.12;
			if(controlsStrings.length < 9) scr = 0;
			controlLabel.scrollFactor.set(0, scr);
			
			grpControls.add(controlLabel);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowThing = new FlxObject(0, 0, 1, 1);
		add(camFollowThing);
		add(camFollow);

		var blackStuff:FlxSprite = new FlxSprite(0, 595).makeGraphic(FlxG.width, 40, FlxColor.BLACK);
		blackStuff.alpha = 0.5;
		blackStuff.screenCenter(X);
		blackStuff.scrollFactor.set();
		add(blackStuff);

		shitText = new FlxText(0, 600, 0, "", 18);
		shitText.setFormat("assets/fonts/vcr.ttf", 25, FlxColor.WHITE, RIGHT);
		shitText.antialiasing = CoolThings.antialiasing;
		shitText.scrollFactor.set();
		add(shitText);

		//FlxG.camera.follow(camFollowThing, null, 1);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		shitText.screenCenter(X);

		if (CoolThings.framerate < 20)
			CoolThings.framerate = 20;

		camFollowThing.setPosition(FlxMath.lerp(camFollowThing.x, camFollow.x, CoolUtil.boundTo(elapsed * 7.5, 0, 1)), FlxMath.lerp(camFollowThing.y, camFollow.y, CoolUtil.boundTo(elapsed * 7.5, 0, 1)));

		FlxGraphic.defaultPersist = CoolThings.persist;

		if (FlxG.keys.justPressed.Y)
		{
			CoolThings.framerate = Application.current.window.displayMode.refreshRate;
			FlxG.updateFramerate = CoolThings.framerate;
			FlxG.drawFramerate = CoolThings.framerate;

		}
		if (FlxG.keys.justPressed.U)
		{
			FlxG.save.data.offset = 1;
		}

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

			fpsText.text = "(Left, Right) | FPS: " + CoolThings.framerate;

			if (curSelected == 0)
			{
				/*fpsText.color = FlxColor.RED;
				offsetText.color = FlxColor.WHITE;*/
				offsetText.alpha = 0.4;
				fpsText.alpha = 1;
			}else 
			{
				/*fpsText.color = FlxColor.WHITE;
				offsetText.color = FlxColor.RED;*/
				offsetText.alpha = 1;
				fpsText.alpha = 0.4;
			}

			shitText.text = descriptionStrings[curSelected];


			if (controls.BACK)
				FlxG.switchState(new OtherOptionsSubState());
			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);
			
			if (controls.LEFT_P)
			{
				if (curSelected == 0)
				{
					CoolThings.framerate -= 10;
					changedFPS();
					
				}else
				{
					CoolThings.offset--;
					offsetText.text = "(Left, Right) | OFFSET: " + CoolThings.offset;
				}

				CoolThings.save();
				
			}
			
			if (controls.RIGHT_P)
			{
				if (curSelected == 0)
				{
					CoolThings.framerate += 10;
					changedFPS();
				}else 
				{
					CoolThings.offset++;
					offsetText.text = "(Left, Right) | OFFSET: " + CoolThings.offset;
				}

				CoolThings.save();
			}

			if (curSelected == 0)
				acceptInput = false;
			else 
				acceptInput = true;

			if (acceptInput)
			{	
				if (controls.ACCEPT)
				{
					if (curSelected != 11 || curSelected != 0)
						grpControls.remove(grpControls.members[curSelected]);
					switch(curSelected)
					{
						case 0: 
							for (item in grpControls.members)
							{
								item.alpha = 0;
						
								if (item.targetY == 0)
								{
									item.alpha = 1;
									//item.setGraphicSize(Std.int(item.width));
								}
							}
						case 1:
							CoolThings.ghost = !CoolThings.ghost;
							var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (CoolThings.ghost ? 'ghost tapping' : 'no ghost tapping'), true, false);
							ctrl.isMenuItem = true;
							grpControls.add(ctrl);
							trace(CoolThings.ghost);
						case 2:
							CoolThings.downscroll = !CoolThings.downscroll;
							var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (CoolThings.downscroll ? "Downscroll" : "Upscroll"), true, false);
							ctrl.isMenuItem = true;
							grpControls.add(ctrl);
							trace(CoolThings.downscroll);
						case 3: 
							CoolThings.middlescroll = !CoolThings.middlescroll;
							var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (CoolThings.middlescroll ? "middlescroll" : "middlescroll off"), true, false);
							ctrl.isMenuItem = true;
							grpControls.add(ctrl);
							trace(CoolThings.middlescroll);
						case 4:
							CoolThings.botplay = !CoolThings.botplay;
							var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (CoolThings.botplay ? 'Botplay on' : 'Botplay off'), true, false);
							ctrl.isMenuItem = true;
							grpControls.add(ctrl);
							trace(CoolThings.botplay);
						case 5:
							CoolThings.showMiss = !CoolThings.showMiss;
							var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (CoolThings.showMiss ? 'Show Miss Counter' : 'Hide Miss Counter'), true, false);
							ctrl.isMenuItem = true;
							grpControls.add(ctrl);
							trace(CoolThings.showMiss);
						case 6:
							CoolThings.showtime = !CoolThings.showtime;
							var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (CoolThings.showtime ? 'Show Song Time' : 'Hide Song Time'), true, false);
							ctrl.isMenuItem = true;
							grpControls.add(ctrl);
							trace(CoolThings.showtime);
						case 7:
							CoolThings.antialiasing = !CoolThings.antialiasing;
							var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (CoolThings.antialiasing ? 'antialiasing' : 'no antialiasing'), true, false);
							ctrl.isMenuItem = true;
							grpControls.add(ctrl);
							trace(CoolThings.antialiasing);
						case 8:
							CoolThings.secretShh = !CoolThings.secretShh;
							var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (CoolThings.secretShh ? 'super secret pause menu ON' : 'super secret pause menu OFF'), true, false);
							ctrl.isMenuItem = true;
							grpControls.add(ctrl);
							trace(CoolThings.secretShh);
						case 9:
							CoolThings.newSplash = !CoolThings.newSplash;
							var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (CoolThings.newSplash ? 'new splash' : 'old splash'), true, false);
							ctrl.isMenuItem = true;
							grpControls.add(ctrl);
							trace(CoolThings.newSplash);
						case 10:
							CoolThings.doSplash = !CoolThings.doSplash;
							var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (CoolThings.doSplash ? 'note splash on' : 'note splash off'), true, false);
							ctrl.isMenuItem = true;
							grpControls.add(ctrl);
							trace(CoolThings.doSplash);
						case 11:
							CoolThings.persist = !CoolThings.persist;
							var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (CoolThings.persist ? 'Persistent Cached Data ON' : 'Persistent Cached Data OFF'), true, false);
							ctrl.isMenuItem = true;
							grpControls.add(ctrl);
							trace(CoolThings.persist);
						case 12:
							CoolThings.displaceCam = !CoolThings.displaceCam;
							var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (CoolThings.displaceCam ? "displace camera" : "do not displace camera"), true, false);
							ctrl.isMenuItem = true;
							grpControls.add(ctrl);
							trace(CoolThings.displaceCam);
						case 13: 
							CoolThings.cpuStrums = !CoolThings.cpuStrums;
							var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (CoolThings.cpuStrums ? "light up cpu strums" : "cpu strums stay static"), true, false);
							ctrl.isMenuItem = true;
							grpControls.add(ctrl);
							trace(CoolThings.cpuStrums);

					}

					CoolThings.save();
				}
			}
	}

	var isSettingControl:Bool = false;

	function changedFPS()
	{
		if(CoolThings.framerate > FlxG.drawFramerate)
		{
			FlxG.updateFramerate = CoolThings.framerate;
			FlxG.drawFramerate = CoolThings.framerate;
		}
		else
		{
			FlxG.drawFramerate = CoolThings.framerate;
			FlxG.updateFramerate = CoolThings.framerate;
		}

		CoolThings.save();
	}

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent('Fresh');
		#end
		
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

	/*	grpControls.forEach(function(spr:MenuOptionItem)
		{
			if (spr.id == curSelected)
			{
				camFollow.setPosition(0, spr.getGraphicMidpoint().y);
			}
		});*/

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			//item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				//item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
