package;

import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.effects.FlxFlicker;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import Config;

import flixel.util.FlxSave;

class OtherOptionsSubState extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;

	private var grpControls:FlxTypedGroup<Alphabet>;

	var camFollow:FlxObject;

	var menuItems:Array<String> = ['preferences', 'controls', 'about', 'exit'];

	var notice:FlxText;

	override function create()
	{
		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		var menuBG:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuDesat.png');
		//controlsStrings = CoolUtil.coolTextFile('assets/data/controls.txt');
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = CoolThings.antialiasing;
		add(menuBG);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...menuItems.length)
		{ 
			var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			controlLabel.screenCenter();
			controlLabel.y = (100 * i) + 100;
			//controlLabel.isMenuItem = true;
			//controlLabel.targetY = i;
			grpControls.add(controlLabel);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}

		changeSelection();

		//FlxG.camera.follow(camFollow, null, 0.06);
		
		super.create();
	}

	var canChange = true;

	override function update(elapsed:Float)
	{

		if (FlxG.keys.justPressed.SEVEN)
			openSubState(new ColorsSubState());
		
		super.update(elapsed);
		if (controls.ACCEPT)
		{
			canChange = false;
			
			FlxG.sound.play(Paths.sound('confirmMenu'));

			var daSelected:String = menuItems[curSelected];

			new FlxTimer().start(0.6, function(_)
			{
				switch (daSelected)
				{
					case "preferences":
						FlxG.switchState(new NEWOptionsSubState());
					case "controls":
						FlxG.switchState(new KeyBindMenu());
					case "colors": 
						openSubState(new ColorsSubState());
					case "about":
						FlxG.switchState(new AboutSubState());
					case "notes":
						FlxG.switchState(new ChangeNotesState());
					case "exit":
						FlxG.switchState(new MainMenuState());
				}
			});
			

			/*grpControls.forEach(function(shit:Alphabet) 
			{
				if (curSelected != menuItems[curSelected])
				{
					FlxTween.tween(shit, {alpha: 0}, 0.4, {ease: FlxEase.quadOut,onComplete: function(twn:FlxTween)
					{
						shit.kill();
					}});

					trace(curSelected + " " + shit.);
				}else
				{
					FlxFlicker.flicker(shit, 1, 0.06, false, false, function(flick:FlxFlicker)
					{
						var daSelected:String = menuItems[curSelected];

						switch (daSelected)
						{
							case "preferences":
								FlxG.switchState(new NEWOptionsSubState());
							case "controls":
								FlxG.switchState(new KeyBindMenu());
							case "colors": 
								openSubState(new ColorsSubState());
							case "about":
								FlxG.switchState(new AboutSubState());
							case "notes":
								FlxG.switchState(new ChangeNotesState());
							case "exit":
								FlxG.switchState(new MainMenuState());
						}
					});
				}
			});*/
		}

		if (canChange)
		{
			if (controls.BACK #if android || FlxG.android.justReleased.BACK #end) {
				FlxG.switchState(new MainMenuState());
			}

			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);
		}

	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			camFollow.setPosition(item.getGraphicMidpoint().y);

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

	override function closeSubState()
		{
			super.closeSubState();
		}	
}
