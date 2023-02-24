package game;

import flixel.util.FlxDestroyUtil;
import flixel.input.gamepad.id.WiiRemoteID;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import game.base.Rating;
import cpp.Int8;
import cpp.Int64;
import flixel.util.FlxColor;
import flixel.ui.FlxBar;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import sys.io.File;
import flixel.input.keyboard.FlxKey;
import openfl.events.KeyboardEvent;
import Controls.KeyboardScheme;
import game.base.Note;
import flixel.FlxG;
import game.base.StrumLine;
import flixel.FlxBasic;
import flixel.group.FlxGroup.FlxTypedGroup;

class UI extends FlxTypedGroup<FlxBasic>
{
	public var dadStrum = new StrumLine(4);
	public var playerStrum = new StrumLine(4, true);
	public var notes:FlxTypedGroup<Note> = new FlxTypedGroup();

	var songstarted:Bool = false;

	public var healthbarBG:FlxSprite;
	public var healthBar:FlxBar;
	public var bfIcon:HealthIcon;
	public var dadIcon:HealthIcon;

	public function new()
	{
		super();
		Conductor.songPosition = -Conductor.crochet * 5;
		dadStrum.screenCenter(X);
		playerStrum.screenCenter(X);
		dadStrum.x -= FlxG.width / 4;
		playerStrum.x += FlxG.width / 4;
		healthbarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Assets.load(IMAGE, Paths.image("healthBar")));
		healthbarBG.screenCenter(X);
		healthBar = new FlxBar(healthbarBG.x + 4, healthbarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthbarBG.width - 8), Std.int(healthbarBG.height - 8),
			PlayState.current, 'health', 0, 2);
		healthBar.createFilledBar(0xFFFF0000, 0xFF5EFF00);
		bfIcon = new HealthIcon('bf', true);
		dadIcon = new HealthIcon('dad', false);

		add(healthbarBG);
		add(healthBar);
		add(bfIcon);
		add(dadIcon);
		bfIcon.y = dadIcon.y = FlxG.height * 0.8;
		add(dadStrum);
		add(playerStrum);
		add(notes);
		genChart();
		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onPress);
		FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, onrealese);
	}

	public function genChart()
	{
		Conductor.changeBPM(PlayState.CHART.bpm);
		for (section in PlayState.CHART.notes)
			for (note in section.sectionNotes)
			{
				var parent:StrumLine = dadStrum;
				var strumTime = note[0];
				var direction = note[1];
				var sustainLength = note[2];
				var morbius:Bool = section.mustHitSection; // this is must press because funni :3
				if (direction >= 4)
					morbius = !morbius;
				if (morbius)
					parent = playerStrum;
				var pressNote = new Note(strumTime, direction, parent);
				pressNote.mustPress = morbius;
				notes.add(pressNote);
			}
	}

	public function popupscore(note:Note)
	{
		var rating = Rating.getFromNote(note);
		var ratingTex = Assets.load(IMAGE, Paths.image('$rating'));
		var ratingSprite:FlxSprite;
		ratingSprite = new FlxSprite(650, 200).loadGraphic(ratingTex);
		ratingSprite.acceleration.y = 550;
		ratingSprite.velocity.y = -150;
		ratingSprite.scale.set(0.7,0.7);
		ratingSprite.updateHitbox();
		ratingSprite.screenCenter();
		add(ratingSprite);
		FlxTween.tween(ratingSprite, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				ratingSprite.kill();
				remove(ratingSprite, true);
			},
			startDelay: Conductor.crochet * 0.001
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (Conductor.songPosition >= 0 && !songstarted)
			startSong();

		Conductor.songPosition += elapsed * 1000;

		notes.forEach(function(note:Note)
		{
			if (Conductor.songPosition - note.strumTime <= -1500)
			{
				note.kill();
				note.active = false;
			}
			else
			{
				note.revive();
				note.active = true;
			}
		});
		notes.forEachAlive(function(note:Note)
		{
			note.y = note.parent.y - (Conductor.songPosition - note.strumTime) / 2 * PlayState.CHART.speed;
			note.x = note.parent.members[note.direction].x;

			if (!note.mustPress)
			{
				if (Conductor.songPosition - note.strumTime >= 0)
					dadNoteHit(note);
			}
		});
		var iconOffset:Int = 26;

		bfIcon.x = healthBar.x + (healthBar.width * (100 - healthBar.percent) / 100 - iconOffset);
		dadIcon.x = healthBar.x + (healthBar.width * (100 - healthBar.percent) / 100 - (dadIcon.width - iconOffset));
	}

	public function dadNoteHit(note:Note)
	{
		dadStrum.members[note.direction].play('confirm', true);
		dadStrum.members[note.direction].centerOffsets();
		dadStrum.members[note.direction].offset.y -= 13;
		dadStrum.members[note.direction].offset.x -= 13;
		dadStrum.members[note.direction].animation.finishCallback = function(name)
		{
			dadStrum.members[note.direction].animation.play('idle');
			dadStrum.members[note.direction].updateHitbox();
		}
		var dirs:Array<String> = ["LEFT", "DOWN", 'UP', 'RIGHT'];
		PlayState.current.dadGroup.forEachAlive(function(char:Character)
		{
			char.holdTimer = 0;
			char.playAnim('sing${dirs[FlxMath.absInt((note.direction % 4))]}', true);
		});
		notes.remove(note, true);
		note.kill();
		note.destroy();
	}

	public function playerNoteHit(note:Note)
	{
		playerStrum.members[note.direction].play('confirm', true);
		playerStrum.members[note.direction].centerOffsets();
		playerStrum.members[note.direction].offset.y -= 13;
		playerStrum.members[note.direction].offset.x -= 13;
		PlayState.current.combo++;
		popupscore(note);
		var dirs:Array<String> = ["LEFT", "DOWN", 'UP', 'RIGHT'];
		PlayState.current.bfGroup.forEachAlive(function(char:Boyfriend)
		{
			char.holdTimer = 0;
			char.playAnim('sing${dirs[FlxMath.absInt((note.direction % 4))]}', true);
		});
		notes.remove(note, true);
		note.kill();
		note.destroy();
	}

	public function startSong()
	{
		songstarted = true;
		trace("starting song");
		FlxG.sound.playMusic(Assets.load(SOUND, Paths.inst(PlayState.CHART.song.toLowerCase())), 1, false);
	}

	// input system
	public var closestNotes:Array<Note> = [];

	var keys:Array<Bool> = [false, false, false, false];
	var binds:Array<String> = ['D', 'F', 'J', 'K'];

	public function onPress(event:KeyboardEvent)
	{
		closestNotes = [];
		notes.forEachAlive(function(note:Note)
		{
			if (note.mustPress && !note.tooLate && note.canHit)
			{
				closestNotes.push(note);
			}
		});
		closestNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
		var data:Int = -1;
		data = binds.indexOf(FlxKey.toStringMap.get(event.keyCode));
		if (data == -1)
			return;
		var dataNotes = [];
		for (i in closestNotes)
			if (i.direction == data && !i.sustain)
				dataNotes.push(i);
		if (dataNotes.length != 0)
		{
			var coolNote = null;

			for (i in dataNotes)
			{
				coolNote = i;
				break;
			}

			// boyfriend.holdTimer = 0;
			playerNoteHit(coolNote);
		}
	}

	public function onrealese(event:KeyboardEvent)
	{
		var data:Int = -1;
		data = binds.indexOf(FlxKey.toStringMap.get(event.keyCode));
		if (data == -1)
			return;
		keys[data] = false;
	}

	override function destroy()
	{
		FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onPress);
		FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, onrealese);
		super.destroy();
	}
}
