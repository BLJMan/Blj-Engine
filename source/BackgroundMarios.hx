package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class BackgroundMarios extends FlxSprite
{
    public var poppedOut:Bool = false;
    public var animOffsets:Map<String, Array<Dynamic>>;

	public function new(x:Float, y:Float)
	{
        animOffsets = new Map<String, Array<Dynamic>>();

		super(x, y);
        frames = Paths.getSparrowAtlas("IHY/Luigi_IHY_Background_Assets_DrownedMario");
		animation.addByPrefix("dance", "DrownedMarioIdle0", 24, false);
		animation.addByPrefix("grab", "DrownedMarioGrab0", 24, false);
		antialiasing = CoolThings.antialiasing;
        alpha = 0.0001;

        animOffsets["dance"] = [0, 0];
        animOffsets["grab"] = [44, 27];

        animation.play("dance");
	}

	public function dance():Void
	{
        var daOffset = animOffsets.get("dance");
        offset.set(daOffset[0], daOffset[1]);
        animation.play("dance");
	}

    public function popOut():Void
    {
        alpha = 1;
        var daOffset = animOffsets.get("grab");
        offset.set(daOffset[0], daOffset[1]);
        animation.play("grab", true);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        if (animation.curAnim.name == "grab")
		{
			if (animation.curAnim.finished)
				poppedOut = true;
        }
    }
}
