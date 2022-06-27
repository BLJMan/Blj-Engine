package;

import flixel.FlxG;
import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		loadGraphic(Paths.image('iconGrid'), true, 150, 150);

		antialiasing = CoolThings.antialiasing;
		animation.add('bf', [0, 1], 0, false, isPlayer);
		animation.add('bf-car', [0, 1], 0, false, isPlayer);
		animation.add('bf-christmas', [0, 1], 0, false, isPlayer);
		animation.add('bf-pixel', [21, 21], 0, false, isPlayer);
		animation.add('spooky', [2, 3], 0, false, isPlayer);
		animation.add('pico', [4, 5], 0, false, isPlayer);
		animation.add('mom', [6, 7], 0, false, isPlayer);
		animation.add('mom-car', [6, 7], 0, false, isPlayer);
		animation.add('tankman', [8, 9], 0, false, isPlayer);
		animation.add('face', [10, 11], 0, false, isPlayer);
		animation.add('dad', [12, 13], 0, false, isPlayer);
		animation.add('senpai', [22, 22], 0, false, isPlayer);
		animation.add('senpai-angry', [22, 22], 0, false, isPlayer);
		animation.add('spirit', [23, 23], 0, false, isPlayer);
		animation.add('bf-old', [14, 15], 0, false, isPlayer);
		animation.add('gf', [16], 0, false, isPlayer);
		animation.add('parents-christmas', [17], 0, false, isPlayer);
		animation.add('monster', [19, 20], 0, false, isPlayer);
		animation.add('monster-christmas', [19, 20], 0, false, isPlayer);
		animation.add('tankman', [8, 9], 0, false, isPlayer);
		animation.add("gf-tankman", [10, 11], 0, false, isPlayer);
		animation.add("bf-holding-gf", [0, 1], 0, false, isPlayer);
		animation.add("picoSpeaker", [10, 11], 0, false, isPlayer);
		animation.add("chara", [10, 11], 0, false, isPlayer);
		animation.add("crewmate", [10, 11], 0, false, isPlayer);
		animation.add("whitty", [10, 11], 0, false, isPlayer);
		animation.add("sonicfun", [10, 11], 0, false, isPlayer);
		animation.add("glitched-bob", [10, 11], 0, false, isPlayer);
		animation.add("sonic.exe", [10, 11], 0, false, isPlayer);
		animation.add("beast", [10, 11], 0, false, isPlayer);
		animation.add("tails", [10, 11], 0, false, isPlayer);
		animation.add("knucks", [10, 11], 0, false, isPlayer);
		animation.add("egg", [10, 11], 0, false, isPlayer);
		animation.add("bfTT", [0, 1], 0, false, isPlayer);
		animation.add("bb", [10, 11], 0, false, isPlayer);
		animation.add("xgaster", [10, 11], 0, false, isPlayer);
		animation.add("edd", [10, 11], 0, false, isPlayer);
		animation.add("edd-alt", [10, 11], 0, false, isPlayer);
		animation.add("eduardo", [10, 11], 0, false, isPlayer);
		animation.add("exe", [10, 11], 0, false, isPlayer);
		animation.add("hypno_MX", [24, 24], 0, false, isPlayer);
		animation.add("lord-x", [24, 24], 0, false, isPlayer);
		animation.play(char);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
