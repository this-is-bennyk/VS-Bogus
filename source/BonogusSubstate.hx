package;

import lime.system.BackgroundWorker;
import flixel.FlxSprite;
import flash.system.System;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class BonogusSubstate extends MusicBeatSubstate
{
    var bonogus:FlxSprite;

	public function new()
	{
		super();

        bonogus = new FlxSprite().loadGraphic(Paths.image('Bonogus')); // 400, 300
        bonogus.scale.set(2, 2);
        bonogus.updateHitbox();
        bonogus.screenCenter();
        bonogus.x += 225;
        bonogus.y += 300;
        add(bonogus);

		FlxG.sound.play(Paths.soundWithExtension('Bonogus Greets You', 'wav'));
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
		{
			System.exit(0);
		}
	}
}
