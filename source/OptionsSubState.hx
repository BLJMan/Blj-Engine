package;

import flixel.addons.transition.FlxTransitionableState;
import haxe.display.Display.Platform;
import flixel.util.FlxSave;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.effects.FlxFlicker;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class OptionsSubState extends MusicBeatState
{
	var textMenuItems:Array<String> = ["Old Input", "Key Binds"];

	var selector:FlxSprite;
	var curSelected:Int = 0;

	var grpOptionsTexts:FlxTypedGroup<FlxText>;

	var fpsThing:FlxUINumericStepper;

	var button:FlxButton;

	var theFps:Float;

	var actualSelector:FlxText;

	override function create()
	{
		super.create();

		FlxG.mouse.visible = true;

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.15;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		grpOptionsTexts = new FlxTypedGroup<FlxText>();
		add(grpOptionsTexts);

		selector = new FlxSprite(20, 25).makeGraphic(30, 30, FlxColor.RED);
		add(selector);

		actualSelector = new FlxText(280, 300, 0, "<", 40);
		actualSelector.visible = true;
		actualSelector.setFormat("assets/fonts/funkin.otf", 50);
		actualSelector.borderStyle = FlxTextBorderStyle.OUTLINE;
		actualSelector.borderColor = FlxColor.BLACK;
		actualSelector.borderSize = 1.5;
		actualSelector.antialiasing = true;
		add(actualSelector);

		fpsThing = new FlxUINumericStepper(130, 150, 10, FlxG.save.data.FPS, 30, 200);
		add(fpsThing);

		button = new FlxButton(120, 170, "change FPS", changeFps);
		add(button);

		for (i in 0...textMenuItems.length)
		{
			var optionText:FlxText = new FlxText(70, 20 + (i * 50), 0, textMenuItems[i], 32);
			optionText.ID = i;
			grpOptionsTexts.add(optionText);
		}
	}

	private function changeFps()
	{
		openfl.Lib.current.stage.frameRate = (fpsThing.value);
		theFps = fpsThing.value;
		FlxG.save.data.FPS = theFps;
		FlxG.save.flush();
	}

	/*	private function updateThing():String
	{
		return "New Input" ;
	}

	private function updatent():String
	{
		return "Old Input" ;
	}
	*/

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var notAllowed:Array<String> = [];

		if (curSelected != 1)
		{
			actualSelector.y = 25;
		}else
		{
			actualSelector.y = 75;
		}

		if(curSelected != 2){

            for(x in textMenuItems){
                if(x != textMenuItems[curSelected]){notAllowed.push(x);}
            }
            
        }
        else {for(x in textMenuItems){notAllowed.push(x);}}


		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(new MainMenuState());
		}
		if (FlxG.keys.justPressed.UP)
		{
			curSelected -= 1;
			FlxG.sound.play('assets/sounds/scrollMenu.ogg');
		}

		if (FlxG.keys.justPressed.DOWN)
		{
			curSelected += 1;
			FlxG.sound.play('assets/sounds/scrollMenu.ogg');
		}

		if (curSelected < 0)
			curSelected = textMenuItems.length - 1;

		if (curSelected >= textMenuItems.length)
			curSelected = 0;

		grpOptionsTexts.forEach(function(txt:FlxText)
		{
			txt.color = FlxColor.WHITE;
			txt.antialiasing = true;
			txt.borderSize = (1.5);

			if (txt.ID == curSelected)
			{
				txt.color = FlxColor.RED;
				txt.scale.set(1.05, 1.05);
				selector.scale.set(1, 1);
			}else
			{
				txt.scale.set(1, 1);
				selector.scale.set(1.05, 1.05);
			}
		});

		grpOptionsTexts.forEach(function(txt:FlxText)
		{
			txt.setFormat("assets/fonts/Funkin-Bold.otf", 50);
			txt.borderStyle = FlxTextBorderStyle.OUTLINE;
			txt.borderColor = FlxColor.BLACK;
			if (PlayState.oldInput)
			{
				//txt.color = FlxColor.YELLOW;
				selector.color = FlxColor.RED;
			}else
			{
				//txt.color = FlxColor.WHITE;
				selector.color = FlxColor.GRAY;
			}
		});


		if (controls.ACCEPT)
		{
			switch (textMenuItems[curSelected])
			{
				//case "Controls":
				//	FlxG.state.closeSubState();
				//	FlxG.state.openSubState(new ControlsSubState());

				case "Old Input":
				{
					if (PlayState.oldInput)
					{
						PlayState.oldInput = false;
					}else
					{
						PlayState.oldInput = true;
					}
					FlxG.sound.play(Paths.sound('confirmMenu'));
					FlxFlicker.flicker(selector, 1, 0.06, true, false, function(flick:FlxFlicker){});
				}
				case "Key Binds":
				{
					FlxG.sound.play('assets/sounds/scrollMenu.ogg');
					FlxG.switchState(new KeyBindMenu());
				}

			}

				
			//FlxG.sound.play(Paths.sound('confirmMenu'));
			//FlxFlicker.flicker(selector, 1, 0.06, true, false, function(flick:FlxFlicker){});
				
				

				

					

					
			
		}
	}
}
