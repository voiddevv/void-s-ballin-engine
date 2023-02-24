package states;

import flixel.group.FlxGroup.FlxTypedGroup;
import lime.app.Application;
import engine.scripting.Hscript;
import openfl.events.MouseEvent;
import openfl.ui.Mouse;
import flixel.FlxG;
import flixel.FlxCamera;
import game.base.Stage;
import game.UI;
import Song.SwagSong;

using StringTools;

class PlayState extends MusicBeatState
{
	public static var CHART:SwagSong;
	public var health:Float = 1.0;

	public var UI:UI;
	public var stage:Stage;
	public var camHUD:FlxCamera = new FlxCamera();
	public var camGame:FlxCamera;

	public static var current:PlayState;

	public var dad:Character;
	public var bf:Boyfriend;
	public var gf:Character;
	public var dadGroup:FlxTypedGroup<Character> = new FlxTypedGroup();
	public var bfGroup:FlxTypedGroup<Boyfriend> = new FlxTypedGroup();
	public var gfGroup:FlxTypedGroup<Character> = new FlxTypedGroup();

	override function create()
	{
		super.create();
		current = this;
		camGame = FlxG.camera;
		FlxG.cameras.add(camHUD, false);
		camHUD.bgColor = 0;
		UI = new UI();
		add(UI);
		UI.cameras = [camHUD];
		stage = new Stage("stage");
		add(stage);
		gf = new Character(400, 130, "gf");
		gfGroup.add(gf);
		dad = new Character(100, 100, "dad");
		dadGroup.add(dad);
		bf = new Boyfriend(770, 450, "bf");
		bfGroup.add(bf);
		add(gfGroup);
		add(dadGroup);
		add(bfGroup);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		// im sorry :C
		bfGroup.forEachAlive(function(bf)
		{
			if (bf.holdTimer > Conductor.stepCrochet * 4 * 0.001 && bf.animation.curAnim.name.startsWith('sing') && !bf.animation.curAnim.name.endsWith('miss'))
			{
				bf.dance();
			}
		});
	}

	override function beatHit()
	{
		super.beatHit();
		bfGroup.forEachAlive(function(bf:Boyfriend)
		{
			if (!bf.animation.name.startsWith('sing'))
				bf.dance();
		}, true);
		dadGroup.forEachAlive(function(dad:Character)
		{
			if (!dad.animation.name.startsWith('sing'))
				dad.dance();
		}, true);
	}
}
