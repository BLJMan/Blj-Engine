package;

import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

class ColorsSubState extends MusicBeatSubstate
{
    private var grpNotes:FlxTypedGroup<FlxSprite>;
    private var grpNumbers:FlxTypedGroup<Alphabet>;

    private static var curSelected:Int = 0;
    private static var typeSelected:Int = 0;

    private var shaderArray:Array<ColorSwap> = [];

    private var hsvTextOffsets:Array<Float> = [240, 90];

    var xPos = 250;

    private var curValue:Float = 0;

    var hsvText:Alphabet;

    var nextAccept:Int = 5;
    
    public function new() 
    {
        super();

        var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.GRAY);
        bg.screenCenter();
        add(bg);

        grpNotes = new FlxTypedGroup<FlxSprite>();
		add(grpNotes);
        grpNumbers = new FlxTypedGroup<Alphabet>();
		add(grpNumbers);

        for (i in 0...CoolUtil.fakeArrowHSV.length)
        {
            var yPos:Float = (165 * i) + 35;
            for (x in 0...3)
            {
                var valText:Alphabet = new Alphabet(0, yPos, Std.string(CoolUtil.fakeArrowHSV[i][x]));
                valText.x = xPos + (225 * x) + 100 - ((valText.length * 90) / 2);
                grpNumbers.add(valText);
            }

            var daNote:FlxSprite = new FlxSprite(xPos -70, yPos);
            daNote.frames = Paths.getSparrowAtlas('UI/NOTE_assets', "shared");
            switch (i)
            {
                case 0: 
                    daNote.animation.addByPrefix('idle', 'purple0');
				case 1:
					daNote.animation.addByPrefix('idle', 'blue0');
				case 2:
					daNote.animation.addByPrefix('idle', 'green0');
				case 3:
					daNote.animation.addByPrefix('idle', 'red0');
            }
            daNote.animation.play("idle");
            daNote.antialiasing = CoolThings.antialiasing;
            grpNotes.add(daNote);

            //got this from psych engine SORRY!!!
            var newShader:ColorSwap = new ColorSwap();
			daNote.shader = newShader.shader;
			newShader.hue = CoolUtil.fakeArrowHSV[i][0] / 360;
			newShader.saturation = CoolUtil.fakeArrowHSV[i][1] / 100;
			newShader.brightness = CoolUtil.fakeArrowHSV[i][2] / 100;
			shaderArray.push(newShader);
        }
        hsvText = new Alphabet(0, 0, "Hue    Saturation  Brightness", false, false, 0, 0.65);
		add(hsvText);
		changeSelection();

        var littleText:FlxText = new FlxText(0, 660, 0, "    I know this looks just like the PsychEngine's menu; I decided to make it in a rush, \nwill modify it on my own whenever I get better at coding lmao --- luv u ShadowMario <3 \n", 16);
        littleText.screenCenter(X);
        add(littleText);
    }

    function changeType(change:Int = 0) 
    {
		typeSelected += change;
		if (typeSelected < 0)
			typeSelected = 2;
		if (typeSelected > 2)
			typeSelected = 0;

		curValue = CoolUtil.fakeArrowHSV[curSelected][typeSelected];
		updateValue();

		for (i in 0...grpNumbers.length) {
			var item = grpNumbers.members[i];
			item.alpha = 0.6;
			if ((curSelected * 3) + typeSelected == i) {
				item.alpha = 1;
			}
		}
	}

    var changingNote:Bool = false;
    override function update(elapsed:Float)
    {
        if (changingNote)
        {
            if (controls.LEFT_P)
            {
                updateValue(-10);
            }else if (controls.RIGHT_P)
            {
                updateValue(10);
            }
        }else 
        {
            if (controls.UP_P)
            {
                changeSelection(-1);
            }
            if (controls.DOWN_P)
            {
                changeSelection(1);
            }
            if (controls.LEFT_P)
            {
                changeType(-1); 
            }
            if (controls.RIGHT_P)
            {
                changeType(1);
            }

            if (controls.ACCEPT && nextAccept <= 0)
            {
                changingNote = true;
                for (i in 0...grpNumbers.length)
                {
                    var item = grpNumbers.members[i];
                    item.alpha = 0;
                    if ((curSelected * 3) + typeSelected == i)
                    {
                        item.alpha = 1;
                    }
                }
                for (i in 0...grpNotes.length) 
                {
					var item = grpNotes.members[i];
					item.alpha = 0;
					if (curSelected == i) {
						item.alpha = 1;
					}
				}
                super.update(elapsed);
                return;
            }
        }

        var lerpVal:Float = CoolUtil.boundTo(elapsed * 9.6, 0, 1);
		for (i in 0...grpNotes.length) {
			var item = grpNotes.members[i];
			var intendedPos:Float = xPos - 70;
			if (curSelected == i) {
				item.x = FlxMath.lerp(item.x, intendedPos + 100, lerpVal);
			} else {
				item.x = FlxMath.lerp(item.x, intendedPos, lerpVal);
			}
			for (j in 0...3) {
				var item2 = grpNumbers.members[(i * 3) + j];
				item2.x = item.x + 265 + (225 * (j % 3)) - (30 * item2.lettersArray.length) / 2;
				if(CoolUtil.fakeArrowHSV[i][j] < 0) {
					item2.x -= 20;
				}
			}

			if(curSelected == i) {
				hsvText.setPosition(item.x + hsvTextOffsets[0], item.y - hsvTextOffsets[1]);
			}
		}

		if (controls.BACK || (changingNote && controls.ACCEPT)) {
			changeSelection();
			if(!changingNote) {
				grpNumbers.forEachAlive(function(spr:Alphabet) {
					spr.alpha = 0;
				});
				grpNotes.forEachAlive(function(spr:FlxSprite) {
					spr.alpha = 0;
				});
				close();
			}
			changingNote = false;
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}

		if(nextAccept > 0) {
			nextAccept -= 1;
		}
		super.update(elapsed);

        FlxG.save.data.arrowHSV = CoolUtil.fakeArrowHSV;

        if(FlxG.save.data.arrowHSV != null) 
        {
			CoolUtil.fakeArrowHSV = FlxG.save.data.arrowHSV;
		}
    }

    function changeSelection(change:Int = 0) 
    {
		curSelected += change;
		if (curSelected < 0)
			curSelected = CoolUtil.fakeArrowHSV.length-1;
		if (curSelected >= CoolUtil.fakeArrowHSV.length)
			curSelected = 0;

		curValue = CoolUtil.fakeArrowHSV[curSelected][typeSelected];
		updateValue();

		for (i in 0...grpNumbers.length) {
			var item = grpNumbers.members[i];
			item.alpha = 0.6;
			if ((curSelected * 3) + typeSelected == i) {
				item.alpha = 1;
			}
		}
		for (i in 0...grpNotes.length) {
			var item = grpNotes.members[i];
			item.alpha = 0.6;
			item.scale.set(1, 1);
			if (curSelected == i) {
				item.alpha = 1;
				item.scale.set(1.2, 1.2);
				hsvText.setPosition(item.x + hsvTextOffsets[0], item.y - hsvTextOffsets[1]);
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

    function updateValue(change:Float = 0) 
    {
		curValue += change;
		var roundedValue:Int = Math.round(curValue);
		var max:Float = 180;
		switch(typeSelected) {
			case 1 | 2: max = 100;
		}

		if(roundedValue < -max) {
			curValue = -max;
		} else if(roundedValue > max) {
			curValue = max;
		}
		roundedValue = Math.round(curValue);
		CoolUtil.fakeArrowHSV[curSelected][typeSelected] = roundedValue;

		switch(typeSelected) {
			case 0: shaderArray[curSelected].hue = roundedValue / 360;
			case 1: shaderArray[curSelected].saturation = roundedValue / 100;
			case 2: shaderArray[curSelected].brightness = roundedValue / 100;
		}
		grpNumbers.members[(curSelected * 3) + typeSelected].changeText(Std.string(roundedValue));
	}
}