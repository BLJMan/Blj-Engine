package;

import flixel.FlxCamera;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;
import flixel.FlxGame;
import openfl.Lib;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import Controls.KeyboardScheme;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import io.newgrounds.NG;
import lime.app.Application;

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'donate', 'kickstarter', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	var camFollowThing:FlxObject;

	var keyShit = new KeyBindMenu();

	public var animOffsets:Map<String, Array<Dynamic>>;

	override function create()
	{
		FlxG.save.data.restarted = false;
		PlayState.freeplayShit = false;

		animOffsets = new Map<String, Array<Dynamic>>();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		FlxG.mouse.visible = false;

		if (FlxG.save.data.FPS == null)
		{
			FlxG.save.data.FPS = 120;
		}

		if (FlxG.save.data.downscroll == null)
		{
			FlxG.save.data.downscroll = false;
		}

		if (FlxG.save.data.scrollSpeed == null)
			FlxG.save.data.scrollSpeed = 1;

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.2;
		bg.setGraphicSize(Std.int(bg.width * 1.2));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = CoolThings.antialiasing;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowThing = new FlxObject(0, 0, 1, 1);
		add(camFollowThing);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.2;
		magenta.setGraphicSize(Std.int(magenta.width * 1.2));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = CoolThings.antialiasing;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('main_menu');

		for (i in 0...optionShit.length)
		{
			createItem(i, tex);
		}

		FlxG.camera.follow(camFollowThing, null, 1);

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, Application.current.meta.get('version') + " | FNF v0.2.7.1", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		if (FlxG.save.data.dfjk == null)
			FlxG.save.data.dfjk = true;

		if (FlxG.save.data.upBind == null)
			FlxG.save.data.upBind = "W";

		if (FlxG.save.data.downBind == null)
			FlxG.save.data.downBind = "S";

		if (FlxG.save.data.leftBind == null)
			FlxG.save.data.leftBind = "A";

		if (FlxG.save.data.rightBind == null)
			FlxG.save.data.rightBind = "D";

		if (FlxG.save.data.killBind == null)
			FlxG.save.data.killBind = "R";

		

		FlxG.save.flush();

		//keyShit.saveKeys();
		PlayerSettings.player1.controls.loadKeyBinds();

		/*if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);
		*/
		trace(FlxG.save.data.dfjk);
		
		changeItem();

		super.create();
	}
	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}

	function createItem(i:Int, tex:FlxAtlasFrames)
	{
		var menuItem:FlxSprite = new FlxSprite(0, -30 + (i * 164));
		menuItem.frames = tex;
		menuItem.animation.addByPrefix('idle', optionShit[i] + " idle", 24);
		menuItem.animation.addByPrefix('selected', optionShit[i] + " selected", 24);
		menuItem.animation.play('idle');
		menuItem.ID = i;
		menuItem.screenCenter(X);
		menuItems.add(menuItem);
		var scr:Float = (optionShit.length - 2) * 0.12;
		if(optionShit.length < 4) scr = 0;
		menuItem.scrollFactor.set(0, scr);
		menuItem.antialiasing = CoolThings.antialiasing;
		menuItem.alpha = 0;
		menuItem.y = (menuItem.y - 100);
		FlxTween.tween(menuItem, {y: menuItem.y + 100, alpha: 1}, 0.7, {ease: FlxEase.circInOut, startDelay: (0.075 * i), onComplete: yuh});
	}

	function yuh(tween:FlxTween)
	{
		changeItem();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.V)
			FlxG.switchState(new LatencyState());
		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		if (FlxG.keys.justPressed.Q)
		{
			menuItems.forEach(function(spr:FlxSprite)
			{
				spr.offset.set(0, 200);
			});
		}

		camFollowThing.setPosition(FlxMath.lerp(camFollowThing.x, camFollow.x, CoolUtil.boundTo(elapsed * 7.5, 0, 1)), FlxMath.lerp(camFollowThing.y, camFollow.y, CoolUtil.boundTo(elapsed * 7.5, 0, 1)));
		
		//keyShit.saveKeys();

		/*if (FlxG.keys.pressed.RIGHT)
		{
			FlxG.save.data.offset++;
			trace(FlxG.save.data.offset);
		}

		if (FlxG.keys.pressed.LEFT)
		{
			FlxG.save.data.offset--;
			trace(FlxG.save.data.offset);
		}*/

		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
				trace("up");
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
				trace("down");
			}

			if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					#if linux
					Sys.command('/usr/bin/xdg-open', ["https://ninja-muffin24.itch.io/funkin", "&"]);
					#else
					FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
					#end
				}else if (optionShit[curSelected] == 'kickstarter')
				{
					FlxG.openURL('https://www.kickstarter.com/projects/funkin/friday-night-funkin-the-full-ass-game');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story mode':
										FlxG.switchState(new StoryMenuState());
										trace("Story Menu Selected");
									case 'freeplay':
										FlxG.switchState(new FreeplayState());

										trace("Freeplay Menu Selected");

									case 'options':
										//FlxTransitionableState.skipNextTransIn = true;
										//FlxTransitionableState.skipNextTransOut = true;
										//FlxG.switchState(new OptionsMenu());
										FlxG.switchState(new OtherOptionsSubState());
								}
							});
						}
					});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();
			spr.screenCenter(X);

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				/*if (curSelected == 0)
					spr.offset.set(70, 25);
				else if (curSelected == 2)
					spr.offset.set(65, 25);
				else */
				if (curSelected == 3)
					spr.offset.set(0, 30);
				else 
					spr.offset.set(0, 25);
				
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
				
			}

			//spr.offset.set(567, -2000);

			spr.width = Math.abs(spr.scale.x) * spr.frameWidth;
			spr.height = Math.abs(spr.scale.y) * spr.frameHeight;

			//spr.updateHitbox();
		});
	}
}
