package;

import flixel.FlxG;

class CoolThings
{
    public static var diffScrollType:Bool = false;
    public static var playstateSong:String = "";
    public static var hitsounds:Bool;
    public static var stages:Array<String> = 
    ["stage", "spooky", "philly", "limo", "mall", "mallEvil", "school", "schoolEvil", "tankStage", "murder", 
    "sonicfunStage", "sonicexeStage", "troubleStage", "mountains", "gamble", "well", "gasterStage", "i hate you", "mario-land"];
    public static var restarted:Bool;

    public static var freeplayCurSelected:Int = 0;
    public static var freeplayCurDiff:Int = 1;

    public static var storyCurSelected:Int = 0;
    public static var storyCurDiff:Int = 1;
    //--------------------------------------------------------
    public static var botplay:Bool;
    public static var antialiasing:Bool;
    public static var ghost:Bool;
    public static var downscroll:Bool;
    public static var middlescroll:Bool;
    public static var showMiss:Bool;
    public static var showtime:Bool;
    public static var secretShh:Bool;
    public static var newSplash:Bool;
    public static var doSplash:Bool;
    public static var persist:Bool;
    public static var offset:Int;
    public static var framerate:Int;
    public static var displaceCam:Bool;
    public static var cpuStrums:Bool;

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

        if (FlxG.save.data.middlescroll != null)
            middlescroll = FlxG.save.data.middlescroll;

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

        if (FlxG.save.data.displace != null)
            displaceCam = FlxG.save.data.displace;

        if (FlxG.save.data.cpu != null)
            cpuStrums = FlxG.save.data.cpu;

        if (FlxG.save.data.hitsounds != null)
            hitsounds = FlxG.save.data.hitsounds;

        #if !html5
            if (FlxG.save.data.FPS != null && FlxG.save.data.FPS > 10 && FlxG.save.data.FPS < 910)
            {
                FlxG.updateFramerate = FlxG.save.data.FPS;
                FlxG.drawFramerate = FlxG.save.data.FPS;

                framerate = FlxG.save.data.FPS;
            }
        #end
    }

    public static function initialize()
    {
        if (FlxG.save.data.botplay == null)
            FlxG.save.data.botplay = false;

        if (FlxG.save.data.antialiasing == null)
            FlxG.save.data.antialiasing = true;

        if (FlxG.save.data.ghost == null)
            FlxG.save.data.ghost = true;

        if (FlxG.save.data.downscroll == null)
            FlxG.save.data.downscroll = false;

        if (FlxG.save.data.middlescroll == null)
            FlxG.save.data.middlescroll = false;

        if (FlxG.save.data.showMiss == null)
            FlxG.save.data.showMiss = true;

        if (FlxG.save.data.showtime == null)
            FlxG.save.data.showtime = true;

        if (FlxG.save.data.rick == null)
            FlxG.save.data.rick = false;

        if (FlxG.save.data.splashlol == null)
            FlxG.save.data.splashlol = false;

        if (FlxG.save.data.doSplash == null)
            FlxG.save.data.doSplash = true;

        if (FlxG.save.data.persist == null)
            FlxG.save.data.persist = false;

        if (FlxG.save.data.offset == null)
            FlxG.save.data.offset = 0;

        if (FlxG.save.data.displace == null)
            FlxG.save.data.displace = false;

        if (FlxG.save.data.cpu == null)
            FlxG.save.data.cpu = true;

        if (FlxG.save.data.hitsounds == null)
            FlxG.save.data.hitsounds = false;
        
        if (FlxG.save.data.FPS == null)
        {
            FlxG.save.data.FPS = 120;
        }
    }

    public static function save()
    {
        FlxG.save.data.botplay = botplay;
        FlxG.save.data.antialiasing = antialiasing;
        FlxG.save.data.ghost = ghost;
        FlxG.save.data.downscroll = downscroll;
        FlxG.save.data.middlescroll = middlescroll;
        FlxG.save.data.showMiss = showMiss;
        FlxG.save.data.showtime = showtime;
        FlxG.save.data.rick = secretShh;
        FlxG.save.data.splashlol = newSplash;
        FlxG.save.data.doSplash = doSplash;
        FlxG.save.data.persist = persist;
        FlxG.save.data.offset = offset;
        FlxG.save.data.FPS = framerate;
        FlxG.save.data.displace = displaceCam;
        FlxG.save.data.cpu = cpuStrums;
        FlxG.save.data.hitsounds = hitsounds;

        FlxG.save.flush();
    }
}