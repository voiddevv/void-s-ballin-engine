package game.base;

import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxSprite;

class FNFSprite extends FlxSprite
{
	var offsets:Map<String, FlxPoint> = [];

	public function new(x:Int = 0, y:Int = 0, graphic:FlxGraphicAsset = null, _antialiasing:Bool = true)
	{
		super(x, y, graphic);
		antialiasing = _antialiasing;
	}

	public function setOffset(anim:String, x:Float, y:Float)
	{
		offsets.set(anim, new FlxPoint(x, y));
	}

	public function play(anim:String, force:Bool = false, reversed:Bool = false, frame:Int = 0)
	{
		if (offsets.exists(anim))
			offset = offsets.get(anim);
		animation.play(anim, force, reversed, frame);
	}
}
