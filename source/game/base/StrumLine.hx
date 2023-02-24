package game.base;

import flixel.FlxG;
import engine.utills.Paths;
import engine.utills.Assets;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

class StrumLine extends FlxTypedSpriteGroup<FNFSprite>
{
	public var player:Bool = false;

	public function new(keys:Int = 4, isPlayer:Bool = false)
	{
		super(0, 50);
		this.player = isPlayer;
		for (i in 0...keys)
		{
			var dirs:Array<String> = ['left', 'down', 'up', 'right'];
			var strum = new FNFSprite(110 * i, 0);
			strum.frames = Assets.load(SPARROW, Paths.image('NOTE_assets'));
			strum.scale.set(0.7, 0.7);
			strum.animation.addByPrefix("idle", '${dirs[i]} arrow', 24, false);
			strum.animation.addByPrefix("confirm", '${dirs[i]} confirm', 24, false);
			strum.animation.addByPrefix("ghost", '${dirs[i]} press', 24, false);
			trace(strum.animation.getNameList());
			strum.animation.play('idle');
			strum.updateHitbox();
			strum.antialiasing = true;
			strum.ID = i;
			add(strum);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (!player)
			return;
		var pressed:Array<Bool> = [
			FlxG.keys.pressed.D,
			FlxG.keys.pressed.F,
			FlxG.keys.pressed.J,
			FlxG.keys.pressed.K
		];
		forEach(function(strum)
		{
			if (!pressed[strum.ID])
			{
				if (strum.animation.name == "confirm" && strum.animation.finished){
					strum.play('idle');
                    strum.updateHitbox();
                    strum.centerOffsets();

                }
                if (strum.animation.name == "ghost")
					strum.play('idle',true);
			}
			if (pressed[strum.ID] && strum.animation.name != 'confirm' && strum.animation.name != 'ghost')
				strum.play('ghost', true);
		}, true);
	}
}
