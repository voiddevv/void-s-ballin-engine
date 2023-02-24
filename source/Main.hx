package;

import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, TitleState,240,240,true));
		addChild(new FPS(10, 3, 0xFFFFFF));
	}
	public function onPress(e:KeyboardEvent) {
		switch (e.keyCode){
			case Keyboard.F5:
				FlxG.resetState();
		}
	}
}
