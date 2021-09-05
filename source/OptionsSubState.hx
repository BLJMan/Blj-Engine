package;

import flixel.util.FlxSave;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.effects.FlxFlicker;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class OptionsSubState extends MusicBeatSubstate
{
	var textMenuItems:Array<String> = ["Old Input"];

	var selector:FlxSprite;
	var curSelected:Int = 0;

	var grpOptionsTexts:FlxTypedGroup<FlxText>;

	var fpsThing:FlxUINumericStepper;

	var button:FlxButton;

	var theFps:Float;

	

	public function new()
	{
		super();

		FlxG.mouse.visible = true;

		grpOptionsTexts = new FlxTypedGroup<FlxText>();
		add(grpOptionsTexts);

		selector = new FlxSprite(20, 25).makeGraphic(30, 30, FlxColor.RED);
		add(selector);

		fpsThing = new FlxUINumericStepper(300, 120, 10, FlxG.save.data.FPS, 30, 200);
		add(fpsThing);

		button = new FlxButton(290, 140, "change FPS", changeFps);
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

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(new MainMenuState());
		}
		if (controls.UP_P)
			curSelected -= 1;

		if (controls.DOWN_P)
			curSelected += 1;

		if (curSelected < 0)
			curSelected = textMenuItems.length - 1;

		if (curSelected >= textMenuItems.length)
			curSelected = 0;

		grpOptionsTexts.forEach(function(txt:FlxText)
		{
			txt.color = FlxColor.WHITE;

			//if (txt.ID == curSelected)
			//	txt.color = FlxColor.YELLOW;

			if (PlayState.oldInput)
			{
				txt.color = FlxColor.YELLOW;
				selector.color = FlxColor.RED;
			}else
			{
				txt.color = FlxColor.WHITE;
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
					if (PlayState.oldInput)
					{
						PlayState.oldInput = false;
					}else
					{
						PlayState.oldInput = true;
					}

				
				FlxG.sound.play(Paths.sound('confirmMenu'));
				FlxFlicker.flicker(selector, 1, 0.06, true, false, function(flick:FlxFlicker)
				{
					//FlxG.switchState(new MainMenuState());
				});
				
				

				

					

					
			}
		}
	}
}
