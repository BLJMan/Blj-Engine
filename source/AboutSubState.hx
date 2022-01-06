package;

import flixel.util.FlxTimer;
import flixel.addons.effects.FlxTrail;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
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

class AboutSubState extends MusicBeatState
{
	var text:Alphabet;
	private var floatshit:Float = 0;
	
	override function create()
	{
		super.create();
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = CoolThings.antialiasing;
		add(menuBG);

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image("cringe", "shared"));
		logo.screenCenter(X);
		logo.scale.set(0.5, 0.5);
		logo.y += 150;
		logo.antialiasing = CoolThings.antialiasing;
		add(logo);

		var leText:FlxText = new FlxText(FlxG.width /2 + 150, FlxG.height / 2 + 100, 0, "<- me");
		leText.setFormat("assets/fonts/Funkin-Bold.otf", 48, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		leText.antialiasing = CoolThings.antialiasing;
		leText.alpha = 0;
		add(leText);

		text = new Alphabet(0, (70) + 50, "BLJ Engine by blj :)", false, false);
		text.screenCenter(X);
		text.alpha = 0;
		add(text);

		//var daTrail = new FlxTrail(text, null, 6, 24, 0.4, 0.055);

		//add(daTrail);

		text.y -= 100;

		FlxTween.tween(text, {y: text.y + 100, alpha: 1}, 1, {ease: FlxEase.elasticOut, startDelay: 0.5 + (0.075)});
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			FlxTween.tween(leText, {alpha: 1}, 1 );
		});
		
		Conductor.changeBPM(102);

	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		floatshit += 0.03;
		text.y += Math.sin(floatshit);

		FlxG.camera.zoom = FlxMath.lerp(1, FlxG.camera.zoom, 0.95);

		if (controls.BACK)
        {
            FlxG.switchState(new OtherOptionsSubState());
        }

		if (controls.ACCEPT)
		{
			FlxG.camera.zoom += 0.03;
		}

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		//trace(FlxG.sound.music);
	}

	override function beatHit()
	{
		super.beatHit();
		FlxG.camera.zoom += 0.03;
	}

}
