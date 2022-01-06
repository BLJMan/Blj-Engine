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

    public static function reload()
    {
        botplay = FlxG.save.data.botplay;
        antialiasing = FlxG.save.data.antialiasing;
        ghost = FlxG.save.data.ghost;
        downscroll = FlxG.save.data.downscroll;
        showMiss = FlxG.save.data.showMiss;
        showtime = FlxG.save.data.showtime;
        secretShh = FlxG.save.data.rick;
        newSplash = FlxG.save.data.splashlol;
        doSplash = FlxG.save.data.doSplash;
        persist = FlxG.save.data.persist;
        offset = FlxG.save.data.offset;
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

        FlxG.save.flush();
    }
}