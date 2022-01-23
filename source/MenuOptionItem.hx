package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class MenuOptionItem extends FlxSpriteGroup
{
	public var targetY:Float = 0;
	public var week:FlxSprite;
	public var flashingInt:Int = 0;
    public var id:Int;

	public function new(y:Int, i:Int, menuItems:Array<String>, id:Int)
	{
		super(x, y);
		week = new Alphabet(0, (y) + 30, menuItems[i], true, false);
        add(week);
        this.id = id;
	}

}
