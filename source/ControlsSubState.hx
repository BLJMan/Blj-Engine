package;//UNUSED

import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;

class ControlsSubState extends FlxSubState
{
	var text:FlxText;

	public function new()
	{
		super();
		text = new FlxText(0, 0, 0, "not working, backspace to exit");
		text.screenCenter();
		text.scale.set(2, 2);
		add(text);

	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.BACKSPACE)
			FlxG.switchState(new MainMenuState());
	}
}
