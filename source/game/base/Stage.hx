package game.base;

import lime.app.Application;
import sys.FileSystem;
import flixel.FlxG;
import engine.scripting.Hscript;
import flixel.FlxBasic;
import flixel.group.FlxGroup.FlxTypedGroup;

class Stage extends FlxTypedGroup<FlxBasic>
{
	var script:Hscript;
	public function new(stage:String = "stage")
	{
		super();
		script = new Hscript();
		script.interp.variables.set("PlayState",PlayState.current);
        script.interp.scriptObject = this;
        script.loadScript('stages/$stage');
        script.call('new');
	}
}
