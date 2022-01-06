package;

import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.FlxG;

class ChangeNotesState extends MusicBeatState
{
    var things:Array<String> = ["old splash", "new splash", "off"];
    var disArray:Array<String> = ["NOTE SPLASH:"];
    var curSelected:Int = 0;
    var daSplash:String;
    var daSplashInt:Int;
    private var grpControls:FlxTypedGroup<Alphabet>;
    var configText:FlxText;
    var descText:FlxText;
    
    override function create() 
    {
        super.create();
        
        var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = CoolThings.antialiasing;
		add(menuBG);

        daSplash = FlxG.save.data.dasplash;
        daSplashInt = things.indexOf(FlxG.save.data.dasplash);
        

       // grpControls = new FlxTypedGroup<Alphabet>();
	//	add(grpControls);

        /*for (i in 0...disArray.length)
		{ 
			var text:Alphabet = new Alphabet(0, (70 * i) + 30, disArray[i], false, false);
			text.screenCenter();
			text.y = (100 * i) + 100;
			//controlLabel.isMenuItem = true;
			//controlLabel.targetY = i;
			grpControls.add(text);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}*/

        configText = new FlxText(0, 215, 1280, "", 48);
		configText.scrollFactor.set(0, 0);
		configText.setFormat("assets/fonts/Funkin-Bold.otf", 48, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		configText.borderSize = 3;
		configText.borderQuality = 1;
		
		descText = new FlxText(320, 638, 640, "", 20);
		descText.scrollFactor.set(0, 0);
		descText.setFormat("assets/fonts/vcr.ttf", 20, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		//descText.borderSize = 3;
		descText.borderQuality = 1;

        add(configText);
		add(descText);

        textUpdate();
    }

    function textUpdate(){

        configText.text = "";

        for(i in 0...disArray.length - 1){

            var textStart = (i == curSelected) ? " " : "  ";
            configText.text += textStart + disArray[i] + ": " + 'old' + "\n";

        }

		var textStart = (curSelected == disArray.length - 1) ? " " : "  ";
		configText.text += textStart + disArray[disArray.length - 1] +  "\n";


    }

    function getSetting(r:Int):Dynamic{

		switch(r){

			case 0: return daSplash;

		}

		return -1;

	}


    override function update(elapsed:Float)
    {
        super.update(elapsed);
        if (controls.BACK)
        {
            FlxG.switchState(new OtherOptionsSubState());
        }

        var daSelected:String = disArray[curSelected];

			switch (daSelected)
			{
				case "NOTE SPLASH:":
				{
                    if (controls.RIGHT_P)
                    {
                       // FlxG.sound.play('assets/sounds/scrollMenu');
                        daSplashInt += 1;
                    }
                        
                    if (controls.LEFT_P)
                    {
                        //FlxG.sound.play('assets/sounds/scrollMenu');
                        daSplashInt -= 1;
                    }
                        
                    if (daSplashInt > 2)
                        daSplashInt = 0;
                    if (daSplashInt < 0)
                        daSplashInt = 2;
                            
                    daSplash = things[daSplashInt];
                }
			}
    }
}