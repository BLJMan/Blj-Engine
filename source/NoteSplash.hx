package;

import flixel.FlxSprite;
import flixel.FlxG;

/*class NoteSplash extends FlxSprite
{
    private var lastNoteType:Int = -1;

    public function new(x:Float = 0, y:Float = 0, ?note:Int = 0)
    {
        super(x, y);

        var skin:String = 'noteSplashes';
        if(PlayState.SONG.splashSkin != null && PlayState.SONG.splashSkin.length > 0) skin = PlayState.SONG.splashSkin;
        
        loadAnims(skin);

        setupNoteSplash(x, y, note);
    }

    public function setupNoteSplash(x:Float, y:Float, note:Int = 0, noteType:Int = 0)
    {
        setPosition(x - Note.swagWidth * 0.95, y - Note.swagWidth);
		alpha = 0.6;

        if(lastNoteType != noteType) {
			var skin:String = 'noteSplashes';
			if(PlayState.SONG.splashSkin != null && PlayState.SONG.splashSkin.length > 0) skin = PlayState.SONG.splashSkin;

			loadAnims(skin);

			lastNoteType = noteType;
		}

        var animNum:Int = FlxG.random.int(1, 2);
		animation.play('note' + note + '-' + animNum, true);
		animation.curAnim.frameRate = 24 + FlxG.random.int(-2, 2);
    }

    function loadAnims(skin:String) 
    {
		frames = Paths.getSparrowAtlas(skin);
		for (i in 1...3) {
			animation.addByPrefix("note1-" + i, "note splash blue " + i, 24, false);
			animation.addByPrefix("note2-" + i, "note splash green " + i, 24, false);
			animation.addByPrefix("note0-" + i, "note splash purple " + i, 24, false);
			animation.addByPrefix("note3-" + i, "note splash red " + i, 24, false);
		}
	}

    override function update(elapsed:Float) {
		if(animation.curAnim.finished) kill();

		super.update(elapsed);
	}
}*/