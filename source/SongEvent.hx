package;

typedef SwagEvent = 
{
    var position:Float;
    var value1:Dynamic;
    var value2:Dynamic;
    var type:String;
	var visPos:String;
}

class SongEvent
{
	public var position:Float;
	public var value1:Dynamic;
	public var value2:Dynamic;
	public var type:String;
	public var visPos:String;

	public function new(pos:Float, value1:Dynamic, value2:Dynamic, type:String, visPos:String)
	{
		this.position = pos;
		this.value1 = value1;
		this.value2 = value2;
		this.type = type;
		this.visPos = visPos;
	}
}