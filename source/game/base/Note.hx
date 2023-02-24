package game.base;

import haxe.io.Float32Array;
import engine.utills.Paths;
import engine.utills.Assets;
import flixel.FlxSprite;

class Note extends FlxSprite
{
	public var direction:Int;
	public var strumTime:Float;
	public var tooLate(get, never):Bool;
	public var canHit(get, never):Bool;
	public var mustPress:Bool = false;
	public var dirs:Array<String> = ['left', 'down', 'up', 'right'];
	public var parent:StrumLine = null;
	public var sustain:Bool = false;

	public function new(strumTime:Float, direction:Int, parent:StrumLine)
	{
		this.strumTime = strumTime;
		this.direction = direction % 4;
		this.parent = parent;
		super(0, -200);
		scale.set(0.7, 0.7);
		antialiasing = true;
		frames = Assets.load(SPARROW, Paths.image('NOTE_assets'));
		animation.addByPrefix('note', '${dirs[this.direction]}0');
		animation.play('note');
		updateHitbox();
	}

	function get_tooLate():Bool
	{
		return Conductor.songPosition >= strumTime + 166;
	}

	function get_canHit():Bool
	{
		return strumTime - Conductor.songPosition <= ((33 * Conductor.safeFrames))
			&& strumTime - Conductor.songPosition >= (((-33 * Conductor.safeFrames)));
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (tooLate)
			alpha = 0.3;
		#if debug
		if (canHit)
			color = 0xFFFF0000;
		else
			color = 0xFFFFFFFF;
		#end
	}
}
