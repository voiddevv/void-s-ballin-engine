package engine.scripting;

import haxe.macro.Expr.Catch;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.system.FlxSound;
import flixel.math.FlxMath;
import hscript.Parser;
import hscript.Interp;
import StringTools;

/**
	class for funni hscript
**/
using StringTools;

class Hscript
{
	public var interp = new Interp();
	public var parser = new Parser();
	public var script:hscript.Expr;

	public function new()
	{
		parser.allowTypes = true;
		parser.allowJSON = true;
		parser.allowMetadata = true;
		interp.variables.set("Int", Int);
		interp.variables.set("String", String);
		interp.variables.set("Float", Float);
		interp.variables.set("Array", Array);
		interp.variables.set("Bool", Bool);
		interp.variables.set("Dynamic", Dynamic);
		interp.variables.set("Math", Math);
		interp.variables.set("Main", Main);
		interp.variables.set("FlxMath", FlxMath);
		interp.variables.set("Std", Std);
		interp.variables.set("StringTools", StringTools);
		interp.variables.set("FlxG", FlxG);
		interp.variables.set("FlxSound", FlxSound);
		interp.variables.set("FlxSprite", FlxSprite);
		interp.variables.set("FlxText", FlxText);
		interp.variables.set("FlxTween", FlxTween);
		interp.variables.set("Paths", Paths);
		interp.variables.set("Assets", Assets);
		interp.variables.set("CoolUtil", CoolUtil);
		interp.errorHandler = function(error)
		{
			trace('HSCRIPT ERROR: at LINE: ${error.line} ${error.toString()}');
		}
	}

	public function call(funcName:String, ?args:Array<Dynamic>):Dynamic
	{
		if (args == null)
			args = [];
		// if(!running) return true;
		try
		{
			var func:Dynamic = interp.variables.get(funcName);
			if (func != null && Reflect.isFunction(func))
				return Reflect.callMethod(null, func, args);
		}
		catch (e)
		{
			// scriptType = EmptyScript;
			FlxG.log.add(e.details());
			// running = false;
		}
		return true;
	}

	public function loadScript(file:String)
	{
		try
		{
			script = parser.parseString(Assets.load(TEXT, (Paths.getPath('$file.hx'))));
			interp.execute(script);
		}
		catch(e){
			trace(e.details());
		}
	}
}
