package;

import engine.scripting.Hscript;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends FlxSprite
{
	public var canDance:Bool = true;
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;
	public var camoffset = [0,0];
	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';
	public var icon = "dad";
	public var holdTimer:Float = 0;
	public var danceSteps:Array<String> = ['idle'];
	public var curDance:Int = 0;
	public var barColor = "0xaf66ce";

	var script = new Hscript();

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;
		antialiasing = true;
		script.interp.scriptObject = this;
		try
		{
			script.loadScript("images/characters/" + curCharacter + "/script");
		}
		catch (e)
		{
			trace(e.details());
		}
		script.call("new");
		dance();
		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	override function update(elapsed:Float)
	{
		script.call('update', [elapsed]);
		if (!curCharacter.startsWith('bf'))
		{
			if (animation.curAnim != null && animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}
			var dadVar:Float = 4.1;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

		super.update(elapsed);
	}

	/**
	 * 
	 */
	public function dance()
	{
		if (!debugMode)
		{
			playAnim(danceSteps[curDance]);
			curDance++;
			if (curDance > danceSteps.length - 1)
				curDance = 0;
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, timer:Float = 0, Reversed:Bool = false, Frame:Int = 0):Void
	{
		if (timer > 0.0)
		{
			canDance = false;
			new FlxTimer().start(timer, function(tmr:FlxTimer)
			{
				canDance = true;
			});
		}

		animation.play(AnimName, Force, Reversed, Frame);
		if(animation.curAnim == null)
			return;
		var daOffset = animOffsets.get(animation.curAnim.name);
		if (animOffsets.exists(animation.curAnim.name))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}