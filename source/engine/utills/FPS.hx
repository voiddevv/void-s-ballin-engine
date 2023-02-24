package engine.utills;

import flixel.math.FlxMath;
import external.memory.Memory;
import haxe.Timer;
import openfl.display.FPS;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**

	* FPS class extension to display memory usage.

	* @author Kirill Poletaev

 */
class FPS extends TextField
{
	private var times:Array<Float>;

	private var memPeak:Float = 0;

	public function new(inX:Float = 10.0, inY:Float = 10.0, inCol:Int = 0xFFFFFF)
	{
		super();

		x = inX;

		y = inY;

		selectable = false;

		defaultTextFormat = new TextFormat("vcr.ttf", 16, inCol);

		text = "FPS: ";

		times = [];

		addEventListener(Event.ENTER_FRAME, onEnter);

		width = 300;

		height = 300;
	}

	private function onEnter(_)
	{
		var now = Timer.stamp();

		times.push(now);

		while (times[0] < now - 1)
			times.shift();

		var mem:Float = FlxMath.roundDecimal(Memory.getCurrentUsage() / 1048576, 3);

		if (mem > memPeak)
			memPeak = mem;

		if (visible)
		{
			text = "FPS: " + times.length + "\nMEM: " + mem + ' / $memPeak MB';
		}
	}
}
