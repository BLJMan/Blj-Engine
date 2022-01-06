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
	var textMenuItems:Array<String> = ["OLD INPUT", "DOWNSCROLL", "BOTPLAY"];

	var selector:FlxSprite;
	var selector2:FlxSprite;
	var selector3:FlxSprite;
	var curSelected:Int = 0;

	var grpOptionsTexts:FlxTypedGroup<FlxText>;

	var fpsThing:FlxUINumericStepper;

	var button:FlxButton;

	var theFps:Float;

	var actualSelector:FlxText;

	var fpsText:FlxText;

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

		selector = new FlxSprite(40, 25).makeGraphic(35, 35, FlxColor.RED);
		add(selector);

		selector2 = new FlxSprite(40, 75).makeGraphic(35, 35, FlxColor.RED);
		add(selector2);

		selector3 = new FlxSprite(40, 125).makeGraphic(35, 35, FlxColor.RED);
		add(selector3);

		actualSelector = new FlxText(320, 300, 0, "<", 40);
		actualSelector.visible = false;
		actualSelector.setFormat("assets/fonts/funkin.otf", 50);
		actualSelector.borderStyle = FlxTextBorderStyle.OUTLINE;
		actualSelector.borderColor = FlxColor.BLACK;
		actualSelector.borderSize = 2;
		actualSelector.borderQuality = 2;
		actualSelector.antialiasing = true;
		add(actualSelector);

		fpsThing = new FlxUINumericStepper(130, 250, 10, FlxG.save.data.FPS, 30, 999);
		add(fpsThing);

		fpsText = new FlxText(120, 270, 0, "FPS CAP :" + FlxG.save.data.FPS, 40);
		fpsText.setFormat("assets/fonts/funkin.otf", 50);
		fpsText.borderStyle = FlxTextBorderStyle.OUTLINE;
		fpsText.borderColor = FlxColor.BLACK;
		//add(fpsText);

		button = new FlxButton(120, 270, "change FPS", changeFps);
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

		fpsText.text = "<  FPS CAP: " + theFps + "  >";

		var notAllowed:Array<String> = [];

		if (curSelected != 1)
		{
			actualSelector.y = 25;
		}else if (curSelected !=2)
		{
			actualSelector.y = 75;
		}else
		{
			actualSelector.y = 125;
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
			FlxG.switchState(new OtherOptionsSubState());
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

		/*if (FlxG.keys.justPressed.RIGHT)
		{
			theFps = FlxG.save.data.FPS + 10;
			changeFps();
		}

		if (FlxG.keys.justPressed.LEFT)
		{
			theFps = FlxG.save.data.FPS - 10;
			changeFps();
		}*/

		if (curSelected < 0)
			curSelected = textMenuItems.length - 1;

		if (curSelected >= textMenuItems.length)
			curSelected = 0;

		grpOptionsTexts.forEach(function(txt:FlxText)
		{
			if (txt.ID == curSelected)
			{
				txt.color = FlxColor.RED;
				//txt.scale.set(1.02, 1.02);
				//selector.scale.set(1, 1);
				txt.x = 80;
				txt.alpha = 1;
			}else
			{
				//txt.scale.set(1, 1);
				txt.x = 80;
				txt.alpha = 0.5;
			}
		});

		grpOptionsTexts.forEach(function(txt:FlxText)
		{
			txt.setFormat("assets/fonts/Funkin-Bold.otf", 50);
			txt.borderStyle = FlxTextBorderStyle.OUTLINE;
			txt.borderColor = FlxColor.BLACK;
			txt.borderSize = 2;
			txt.borderQuality = 2;
			txt.color = FlxColor.WHITE;
			txt.antialiasing = true;
			
			if (CoolThings.ghost)
			{
				//txt.color = FlxColor.YELLOW;
				selector.color = FlxColor.GRAY;
			}else
			{
				//txt.color = FlxColor.WHITE;
				selector.color = FlxColor.RED;
			}

			if (CoolThings.downscroll)
			{
				//txt.color = FlxColor.YELLOW;
				selector2.color = FlxColor.RED;
			}else
			{
				//txt.color = FlxColor.WHITE;
				selector2.color = FlxColor.GRAY;
			}

			if (FlxG.save.data.botplay)
			{
				//txt.color = FlxColor.YELLOW;
				selector3.color = FlxColor.RED;
			}else
			{
				//txt.color = FlxColor.WHITE;
				selector3.color = FlxColor.GRAY;
			}
		});


		if (controls.ACCEPT)
		{
			switch (textMenuItems[curSelected])
			{
				//case "Controls":
				//	FlxG.state.closeSubState();
				//	FlxG.state.openSubState(new ControlsSubState());

				case "OLD INPUT":
				{
					if (CoolThings.ghost)
					{
						CoolThings.ghost = false;
					}else
					{
						CoolThings.ghost = true;
					}
					FlxG.sound.play(Paths.sound('confirmMenu'));
					FlxFlicker.flicker(selector, 1, 0.06, true, false, function(flick:FlxFlicker){});
				}
				case "DOWNSCROLL":
				{
					if (CoolThings.downscroll)
					{
						CoolThings.downscroll = false;
					}else
					{
						CoolThings.downscroll = true;
					}
					trace(CoolThings.downscroll);
					FlxG.sound.play(Paths.sound('confirmMenu'));
					FlxFlicker.flicker(selector2, 1, 0.06, true, false, function(flick:FlxFlicker){});
				}
				case "KEY BINDS":
				{
					FlxG.sound.play('assets/sounds/scrollMenu.ogg');
					FlxG.switchState(new KeyBindMenu());
				}
				case "BOTPLAY":
				{
					if (FlxG.save.data.botplay)
					{
						FlxG.save.data.botplay = false;
					}else
					{
						FlxG.save.data.botplay = true;
					}
					FlxG.sound.play(Paths.sound('confirmMenu'));
					FlxFlicker.flicker(selector3, 1, 0.06, true, false, function(flick:FlxFlicker){});
					trace(FlxG.save.data.botplay);
				}

			}

				
			//FlxG.sound.play(Paths.sound('confirmMenu'));
			//FlxFlicker.flicker(selector, 1, 0.06, true, false, function(flick:FlxFlicker){});
				
				

				

					

					
			
		}
	}
}
