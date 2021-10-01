package;

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

	private var grpControls:FlxTypedGroup<Alphabet>;
	var versionShit:FlxText;
	override function create()
	{

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		controlsStrings = CoolUtil.coolStringFile(
			(FlxG.save.data.ghost ? 'New Input' : 'Old Input') + "\n" + 
			(FlxG.save.data.downscroll ? 'Downscroll' : 'Upscroll') + "\n" + 
			(FlxG.save.data.botplay ? 'Botplay on' : 'Botplay off') + "\n" + 
			(FlxG.save.data.showMiss ? 'Show Miss Counter' : 'Hide Miss Counter') + "\n" + 
			(FlxG.save.data.showtime ? 'Show song time' : 'Hide song time') + "\n" +
			(FlxG.save.data.antialiasing ? 'antialiasing' : 'no antialiasing') + "\n" + 
			"(shift) to change FPS");
		
		trace(controlsStrings);

		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = FlxG.save.data.antialiasing;
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

		fpsText = new FlxText(55, 695, 0, FlxG.save.data.FPS, 10);
		fpsText.scrollFactor.set();
		fpsText.scale.set(1.4, 1.4);
		fpsText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(fpsText);

		for (i in 0...controlsStrings.length)
		{
				var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, controlsStrings[i], true, false);
				controlLabel.isMenuItem = true;
				controlLabel.targetY = i;
                controlLabel.screenCenter(X);
				grpControls.add(controlLabel);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

			fpsText.text = "(SHIFT + Left, Right) | FPS: " + FlxG.save.data.FPS;

			if (FlxG.keys.pressed.SHIFT)
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

			if (openfl.Lib.current.stage.frameRate < FlxG.save.data.FPS)
				openfl.Lib.current.stage.frameRate = FlxG.save.data.FPS;

			if (controls.BACK)
				FlxG.switchState(new OtherOptionsSubState());
			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);
			
			if (controls.LEFT_P)
			{
				if (FlxG.keys.pressed.SHIFT)
				{
					FlxG.save.data.FPS -= 10;
					openfl.Lib.current.stage.frameRate = FlxG.save.data.FPS;
					
				}else
				{
				FlxG.save.data.offset--;
				offsetText.text = "(Left, Right) | OFFSET: " + FlxG.save.data.offset;
				}
			}
			
			if (controls.RIGHT_P)
			{
				if (FlxG.keys.pressed.SHIFT)
				{
					FlxG.save.data.FPS += 10;
					openfl.Lib.current.stage.frameRate = FlxG.save.data.FPS;
				}else 
				{
				FlxG.save.data.offset++;
				offsetText.text = "(Left, Right) | OFFSET: " + FlxG.save.data.offset;
				}
			}

			if (controls.ACCEPT)
			{
				if (curSelected != 6)
					grpControls.remove(grpControls.members[curSelected]);
				switch(curSelected)
				{
					case 0:
						FlxG.save.data.ghost = !FlxG.save.data.ghost;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.ghost ? 'New Input' : 'Old Input'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected;
						grpControls.add(ctrl);
                        trace(FlxG.save.data.ghost);
                        /*if (FlxG.save.data.ghost)
				    	{
					    	FlxG.save.data.ghost = false;
					    }else
					    {
					    	FlxG.save.data.ghost = true;
					    }*/
						
					case 1:
						FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.downscroll ? "Downscroll" : "Upscroll"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 1;
						grpControls.add(ctrl);
                        trace(FlxG.save.data.downscroll);
                        /*if (FlxG.save.data.downscroll)
                        {
                            FlxG.save.data.downscroll = false;
                        }else
                        {
                            FlxG.save.data.downscroll = true;
                        }*/
					case 2:
						FlxG.save.data.botplay = !FlxG.save.data.botplay;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.botplay ? 'Botplay on' : 'Botplay off'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 2;
						grpControls.add(ctrl);
                        trace(FlxG.save.data.botplay);
                        /*if (FlxG.save.data.botplay)
                        {
                            FlxG.save.data.botplay = false;
                        }else
                        {
                            FlxG.save.data.botplay = true;
                        }*/
					case 3:
						FlxG.save.data.showMiss = !FlxG.save.data.showMiss;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.showMiss ? 'Show Miss Counter' : 'Hide Miss Counter'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 3;
						grpControls.add(ctrl);
                        trace(FlxG.save.data.showMiss);
					case 4:
						FlxG.save.data.showtime = !FlxG.save.data.showtime;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.showtime ? 'Show Song Time' : 'Hide Song Time'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 4;
						grpControls.add(ctrl);
                        trace(FlxG.save.data.showtime);
					case 5:
						FlxG.save.data.antialiasing = !FlxG.save.data.antialiasing;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.antialiasing ? 'antialiasing' : 'no antialiasing'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 5;
						grpControls.add(ctrl);
                        trace(FlxG.save.data.antialiasing);
				}
			}
	}

	var isSettingControl:Bool = false;

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

		for (item in grpControls.members)
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
