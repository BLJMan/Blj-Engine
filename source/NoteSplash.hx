package;

import flixel.FlxG;
import flixel.FlxSprite;

class NoteSplash extends FlxSprite
{
	var colorSwap:ColorSwap;

	public function new(xPos:Float, yPos:Float, ?c:Int)
	{
		if (c == null)
			c = 0;
		super(xPos, yPos);

		if (!CoolThings.newSplash)
		{
			frames = Paths.getSparrowAtlas('UI/noteSplashes', 'shared');
			animation.addByPrefix("note1-0", "note impact 1  blue", 24, false);
			animation.addByPrefix("note2-0", "note impact 1 green", 24, false);
			animation.addByPrefix("note0-0", "note impact 1 purple", 24, false);
			animation.addByPrefix("note3-0", "note impact 1 red", 24, false);

			animation.addByPrefix("note1-1", "note impact 2 blue", 24, false);
			animation.addByPrefix("note2-1", "note impact 2 green", 24, false);
			animation.addByPrefix("note0-1", "note impact 2 purple", 24, false);
			animation.addByPrefix("note3-1", "note impact 2 red", 24, false);
		}else 
		{
			frames = Paths.getSparrowAtlas('UI/AllnoteSplashes', 'shared');
			animation.addByPrefix("note1-0", "BlueC instance 1", 24, false);
			animation.addByPrefix("note2-0", "GreenC instance 1", 24, false);
			animation.addByPrefix("note0-0", "PurpC instance 1", 24, false);
			animation.addByPrefix("note3-0", "RedC instance 1", 24, false);
		}

		setupNoteSplash(xPos, xPos, c);
	}

	public function setupNoteSplash(xPos:Float, yPos:Float, ?c:Int)
	{
		if (c == null)
			c = 0;

		colorSwap = new ColorSwap();
		colorSwap.hue = CoolUtil.arrowHSV[c % 4][0] / 360;
		colorSwap.saturation = CoolUtil.arrowHSV[c % 4][1] / 100;
		colorSwap.brightness = CoolUtil.arrowHSV[c % 4][2] / 100;
		shader = colorSwap.shader;

		setPosition(xPos, yPos);
		if (!CoolThings.newSplash)
			alpha = 0.7;
		else 
			alpha = 0.6;

		if (!CoolThings.newSplash)
		{
			animation.play("note" + c + "-" + FlxG.random.int(0, 1), true);
		}else 
		{
			animation.play("note" + c + "-0", true);
		}
		
		//animation.curAnim.frameRate = 24 + FlxG.random.int(-3, 3);
		updateHitbox();
		offset.set(0.3 * width, 0.3 * height);
	}

	override public function update(elapsed)
	{
		if (animation.curAnim.finished)
			kill();
		super.update(elapsed);
	}
}
