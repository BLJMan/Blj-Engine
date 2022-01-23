package;

import flixel.FlxG;

class CoolThings
{
    public static var diffScrollType:Bool = false;
    //--------------------------------------------------------
    public static var botplay:Bool;
    public static var antialiasing:Bool;
    public static var ghost:Bool;
    public static var downscroll:Bool;
    public static var showMiss:Bool;
    public static var showtime:Bool;
    public static var secretShh:Bool;
    public static var newSplash:Bool;
    public static var doSplash:Bool;
    public static var persist:Bool;
    public static var offset:Int;
    public static var framerate:Int;

    public static function reload()
    {
        if (FlxG.save.data.botplay != null)
            botplay = FlxG.save.data.botplay;

        if (FlxG.save.data.antialiasing != null)
            antialiasing = FlxG.save.data.antialiasing;

        if (FlxG.save.data.ghost != null)
            ghost = FlxG.save.data.ghost;

        if (FlxG.save.data.downscroll != null)
            downscroll = FlxG.save.data.downscroll;

        if (FlxG.save.data.showMiss != null)
            showMiss = FlxG.save.data.showMiss;

        if (FlxG.save.data.showtime != null)
            showtime = FlxG.save.data.showtime;

        if (FlxG.save.data.rick != null)
            secretShh = FlxG.save.data.rick;

        if (FlxG.save.data.splashlol != null)
            newSplash = FlxG.save.data.splashlol;

        if (FlxG.save.data.doSplash != null)
            doSplash = FlxG.save.data.doSplash;

        if (FlxG.save.data.persist != null)
            persist = FlxG.save.data.persist;

        if (FlxG.save.data.offset != null)
            offset = FlxG.save.data.offset;

        if (FlxG.save.data.FPS != null && FlxG.save.data.FPS > 10 && FlxG.save.data.FPS < 910)
        {
            FlxG.updateFramerate = FlxG.save.data.FPS;
            FlxG.drawFramerate = FlxG.save.data.FPS;

            framerate = FlxG.save.data.FPS;
        }
    }

    public static function save()
    {
        FlxG.save.data.botplay = botplay;
        FlxG.save.data.antialiasing = antialiasing;
        FlxG.save.data.ghost = ghost;
        FlxG.save.data.downscroll = downscroll;
        FlxG.save.data.showMiss = showMiss;
        FlxG.save.data.showtime = showtime;
        FlxG.save.data.rick = secretShh;
        FlxG.save.data.splashlol = newSplash;
        FlxG.save.data.doSplash = doSplash;
        FlxG.save.data.persist = persist;
        FlxG.save.data.offset = offset;
        FlxG.save.data.FPS = framerate;

        FlxG.save.flush();
    }
}