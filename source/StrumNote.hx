package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class StrumNote extends FlxSprite
{
	private var colorSwap:ColorSwap;
	public var resetAnim:Float = 0;
	private var noteData:Int = 0;

	private var isPixelStage:Bool;

	private var player:Int;

	public function new(x:Float, y:Float, leData:Int, player:Int) 
	{
		colorSwap = new ColorSwap();
		shader = colorSwap.shader;
		noteData = leData;
		isPixelStage = PlayState.isPixelArrows;
		
		this.player = player;
		this.noteData = leData;
		super(x, y);

		if (isPixelStage)
		{
			loadGraphic(Paths.image('UI/arrows-pixels'));
			width = width / 4;
			height = height / 5;
			loadGraphic(Paths.image('UI/arrows-pixels'), true, 17, 17);
			animation.add('green', [6]);
			animation.add('red', [7]);
			animation.add('blue', [5]);
			animation.add('purple', [4]);

			antialiasing = false;
			setGraphicSize(Std.int(width * PlayState.daPixelZoom));

			switch (Math.abs(leData))
			{
				case 0:
					animation.add('static', [0]);
					animation.add('pressed', [4, 8], 12, false);
					animation.add('confirm', [12, 16], 24, false);
				case 1:
					animation.add('static', [1]);
					animation.add('pressed', [5, 9], 12, false);
					animation.add('confirm', [13, 17], 24, false);
				case 2:
					animation.add('static', [2]);
					animation.add('pressed', [6, 10], 12, false);
					animation.add('confirm', [14, 18], 12, false);
				case 3:
					animation.add('static', [3]);
					animation.add('pressed', [7, 11], 12, false);
					animation.add('confirm', [15, 19], 24, false);
			}
		}else 
		{
			frames = Paths.getSparrowAtlas('UI/NOTE_assets');
			animation.addByPrefix('green', 'arrowUP');
			animation.addByPrefix('blue', 'arrowDOWN');
			animation.addByPrefix('purple', 'arrowLEFT');
			animation.addByPrefix('red', 'arrowRIGHT');

			antialiasing = CoolThings.antialiasing;
			setGraphicSize(Std.int(width * 0.7));

			switch (Math.abs(leData))
			{
				case 0:
					animation.addByPrefix('static', 'arrowLEFT');
					animation.addByPrefix('pressed', 'left press', 24, false);
					animation.addByPrefix('confirm', 'left confirm', 24, false);
				case 1:
					animation.addByPrefix('static', 'arrowDOWN');
					animation.addByPrefix('pressed', 'down press', 24, false);
					animation.addByPrefix('confirm', 'down confirm', 24, false);
				case 2:
					animation.addByPrefix('static', 'arrowUP');
					animation.addByPrefix('pressed', 'up press', 24, false);
					animation.addByPrefix('confirm', 'up confirm', 24, false);
				case 3:
					animation.addByPrefix('static', 'arrowRIGHT');
					animation.addByPrefix('pressed', 'right press', 24, false);
					animation.addByPrefix('confirm', 'right confirm', 24, false);
			}
		}

		updateHitbox();
		scrollFactor.set();
	}

	public function afterGenerating()
	{
		playAnim('static');
		x += Note.swagWidth * noteData;
		x += 100;

		if (CoolThings.middlescroll)
			x += (FlxG.width / 2) - (Note.swagWidth * 2) - 100;
		else 
			x += ((FlxG.width / 2) * player);

		ID = noteData;
	}

	override function update(elapsed:Float) 
	{
		if(resetAnim > 0) 
		{
			resetAnim -= elapsed;
			if(resetAnim <= 0) 
			{
				playAnim('static');
				resetAnim = 0;
			}
		}

		super.update(elapsed);
	}

	public function playAnim(anim:String, ?force:Bool = false) 
	{
		animation.play(anim, force);
		centerOffsets();
		if(animation.curAnim == null || animation.curAnim.name == 'static') 
		{
			colorSwap.hue = 0;
			colorSwap.saturation = 0;
			colorSwap.brightness = 0;
		} else 
		{
			colorSwap.hue = CoolUtil.arrowHSV[noteData % 4][0] / 360;
			colorSwap.saturation = CoolUtil.arrowHSV[noteData % 4][1] / 100;
			colorSwap.brightness = CoolUtil.arrowHSV[noteData % 4][2] / 100;

			if(animation.curAnim.name == 'confirm' && !isPixelStage) 
			{
				updateConfirmOffset();
			}
		}
	}

	function updateConfirmOffset() 
	{ 
		centerOffsets();
		offset.x -= 13;
		offset.y -= 13;
	}
}
