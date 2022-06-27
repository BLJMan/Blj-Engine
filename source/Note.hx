package;

import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var botCanHit:Bool = false;
	public var ignoreNote:Bool = false;
	public var prevNote:Note;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	public var noteType:Int = 0;

	public var gfNote:Bool = false;

	public var modifiedByLua:Bool = false;

	public var noteScore:Float = 1;

	public var colorSwap:ColorSwap;

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;
	//public static var RED_NOTE_TWO:Int = 4;


	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, noteType:Int = 0, ?editor:Bool = true)
	{
		super();

		this.noteType = noteType;

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		x += 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		this.strumTime = strumTime;

		if (!editor)
			this.strumTime += CoolThings.offset;

		this.noteData = noteData;

		var daStage:String = PlayState.curStage;

		colorSwap = new ColorSwap();
		colorSwap.hue = CoolUtil.arrowHSV[noteData % 4][0] / 360;
		colorSwap.saturation = CoolUtil.arrowHSV[noteData % 4][1] / 100;
		colorSwap.brightness = CoolUtil.arrowHSV[noteData % 4][2] / 100;
		shader = colorSwap.shader;

		if (PlayState.isPixelArrows)
		{
			loadGraphic(Paths.image('UI/arrows-pixels'), true, 17, 17);

			animation.add('greenScroll', [6]);
			animation.add('redScroll', [7]);
			animation.add('blueScroll', [5]);
			animation.add('purpleScroll', [4]);

			if (isSustainNote)
			{
				loadGraphic(Paths.image('UI/arrowEnds'), true, 7, 6);

				animation.add('purpleholdend', [4]);
				animation.add('greenholdend', [6]);
				animation.add('redholdend', [7]);
				animation.add('blueholdend', [5]);

				animation.add('purplehold', [0]);
				animation.add('greenhold', [2]);
				animation.add('redhold', [3]);
				animation.add('bluehold', [1]);
			}

			setGraphicSize(Std.int(width * PlayState.daPixelZoom));
			updateHitbox();
		}else 
		{
			switch (noteType)
			{
				case 2: //static note, must press
				{
					frames = Paths.getSparrowAtlas('UI/staticNotes');
					animation.addByPrefix('greenScroll', 'green static');
					animation.addByPrefix('redScroll', 'red static');
					animation.addByPrefix('blueScroll', 'blue static');
					animation.addByPrefix('purpleScroll', 'purple static');

					animation.addByPrefix('purpleholdend', 'pruple end hold');
					animation.addByPrefix('greenholdend', 'green hold end');
					animation.addByPrefix('redholdend', 'red hold end');
					animation.addByPrefix('blueholdend', 'blue hold end');

					animation.addByPrefix('purplehold', 'purple hold piece');
					animation.addByPrefix('greenhold', 'green hold piece');
					animation.addByPrefix('redhold', 'red hold piece');
					animation.addByPrefix('bluehold', 'blue hold piece');

					setGraphicSize(Std.int(width * 0.7));
					
					updateHitbox();
					antialiasing = true;
				}

				case 3: //hurt note, must NOT press
				{
					frames = Paths.getSparrowAtlas('UI/HURTNOTE_assets');
					animation.addByPrefix('greenScroll', 'green0');
					animation.addByPrefix('redScroll', 'red0');
					animation.addByPrefix('blueScroll', 'blue0');
					animation.addByPrefix('purpleScroll', 'purple0');
	
					setGraphicSize(Std.int(width * 0.7));
									
					updateHitbox();
					antialiasing = true;
				}


				default: 
				{
					frames = Paths.getSparrowAtlas('UI/NOTE_assets');

					animation.addByPrefix('greenScroll', 'green0');
					animation.addByPrefix('redScroll', 'red0');
					animation.addByPrefix('blueScroll', 'blue0');
					animation.addByPrefix('purpleScroll', 'purple0');

					animation.addByPrefix('purpleholdend', 'pruple end hold');
					animation.addByPrefix('greenholdend', 'green hold end');
					animation.addByPrefix('redholdend', 'red hold end');
					animation.addByPrefix('blueholdend', 'blue hold end');

					animation.addByPrefix('purplehold', 'purple hold piece');
					animation.addByPrefix('greenhold', 'green hold piece');
					animation.addByPrefix('redhold', 'red hold piece');
					animation.addByPrefix('bluehold', 'blue hold piece');

					setGraphicSize(Std.int(width * 0.7));
					updateHitbox();
					antialiasing = CoolThings.antialiasing;
				}
			}

			if (editor)
			{
				if (noteType == 1) 
				{
					frames = Paths.getSparrowAtlas('UI/NOTE_assets_bruh');

					animation.addByPrefix('greenScroll', 'green0');
					animation.addByPrefix('redScroll', 'red0');
					animation.addByPrefix('blueScroll', 'blue0');
					animation.addByPrefix('purpleScroll', 'purple0');

					setGraphicSize(Std.int(width * 0.7));
					updateHitbox();
					antialiasing = CoolThings.antialiasing;
				}
			}
		}

		

		switch (noteData)
		{
			case 0:
				x += swagWidth * 0;
				animation.play('purpleScroll');
			case 1:
				x += swagWidth * 1;
				animation.play('blueScroll');
			case 2:
				x += swagWidth * 2;
				animation.play('greenScroll');
			case 3:
				x += swagWidth * 3;
				animation.play('redScroll');
		}

		//trace(noteData);

		if (isSustainNote && prevNote != null)
		{
			noteScore * 0.2;
			alpha = 0.6;

			x += width / 2;

			switch (noteData)
			{
				case 2:
					animation.play('greenholdend');
				case 3:
					animation.play('redholdend');
				case 1:
					animation.play('blueholdend');
				case 0:
					animation.play('purpleholdend');
			}

			updateHitbox();

			x -= width / 2;

			if (PlayState.isPixelArrows)
				x += 30;

			if (prevNote.isSustainNote)
			{
				switch (prevNote.noteData)
				{
					case 0:
						prevNote.animation.play('purplehold');
					case 1:
						prevNote.animation.play('bluehold');
					case 2:
						prevNote.animation.play('greenhold');
					case 3:
						prevNote.animation.play('redhold');
				}


				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();

				if (CoolThings.downscroll && sustainNote) 
					flipY = true;
			}
		} 
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (y < FlxG.height)
			visible = true; 
		else 
			visible = false;

		if (mustPress)
		{
			// The * 0.5 is so that it's easier to hit them too late, instead of too early
			if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
				&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
				canBeHit = true;
			else
				canBeHit = false;

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit)
				tooLate = true;

			if (strumTime <= Conductor.songPosition)
			{
				botCanHit = true;
			}
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
			{
				wasGoodHit = true;
			}
		}

		if (tooLate)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
}
