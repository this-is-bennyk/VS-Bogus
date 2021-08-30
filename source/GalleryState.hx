package;

import flixel.FlxSprite;
#if windows
import Discord.DiscordClient;
#end
import flixel.util.FlxColor;
import openfl.Lib;
import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.input.gamepad.FlxGamepad;

class GalleryState extends MusicBeatState
{
    public var imageNames:Array<String> = [
        'Bogus Spin',
        'Elite Spin',
        'BFGF Spin',
        'bogusbirth',
        'bogusdesign',
        'bogusscary',
        'bogusfaces',
        'BogusArmy',
        'baeb3',
        'EliteGreet1',
        'Bogus Spitter',
        'RoxyCancelledConcept',
        'RoxyBattleBGUnfin',
        'UnfinKatara'
    ];
    public var imageDescs:Array<String> = [
        'Turnaround of Bogus, the Redditor.',
        'Turnaround of Bogus Elite, the Angry Redditor.',
        'Turnaround of BF and GF.',
        'The origin (or birth) of Bogus: a shitpost in WHITE SPACE, VRChat.',
        'The first proper drawing of Bogus.',
        'The first appearance of Bogus Elite.',
        'Bogus making faces.',
        'An army of Bogi (plural version of Bogus).',
        'The reveal art for VS Bogus.',
        'Bogus Elite\'s signature greeting.',
        'A Bogus as a Spitter from L4D2.',
        'Concept for a cancelled Roxy mod.',
        'An unfinished BG for the cancelled Roxy mod.',
        'Roxy and Katara concepts for the cancelled Roxy mod.'
    ];

    public var images:Array<FlxSprite> = [];
    public var dropShadow:FlxSprite = new FlxSprite(0, -65, Paths.image('gallery/gallery_dropshadow'));
    public var descText:FlxText;
    public var leftArrow:FlxSprite;
    public var rightArrow:FlxSprite;

    private var curIdx:Int = 0;
    private var movedBack = false;

    override function create()
    {
        // Add BG
        var bg = new FlxSprite(0, 0, Paths.image('gallery/gallery_gradient'));
        // bg.screenCenter();
        add(bg);

        // Add drop shadow
        add(dropShadow);

        // Add sprites
        for (i in 0...imageNames.length) {
            var curItem:FlxSprite;
            var imageName = imageNames[i];

            if (i < 3) {
                curItem = new FlxSprite();
                curItem.frames = Paths.getSparrowAtlas('gallery/' + imageName);
                curItem.animation.addByPrefix('spin', imageName + " idle", 6);
                curItem.animation.play('spin');
            } else {
                curItem = new FlxSprite(0, 0, Paths.image('gallery/' + imageName));
            }

            curItem.screenCenter();
            curItem.visible = i == curIdx;
            images.push(curItem);

            add(curItem);
        }
        
        // Add UI
        descText = new FlxText(0, 672, 0, imageDescs[curIdx], 24);
        descText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        descText.borderSize = 2;
        descText.screenCenter(X);
        add(descText);

        var returnText = new FlxText(10, 70, 0, 'Press ESC to return.', 24);
        returnText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        returnText.borderSize = 2;
        add(returnText);

        var arrowTex = Paths.getSparrowAtlas('too_lazy_to_make_a_new_sheet');

        leftArrow = new FlxSprite(60, 0);
        leftArrow.frames = arrowTex;
        leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left", 24, false);
		leftArrow.animation.play('idle');
        leftArrow.screenCenter(Y);
        add(leftArrow);

        rightArrow = new FlxSprite(1280 - 35 - 60, 0);
        rightArrow.frames = arrowTex;
        rightArrow.animation.addByPrefix('idle', "arrow right");
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
        rightArrow.screenCenter(Y);
        add(rightArrow);

        var galleryTitle = new FlxSprite(10, 10);
        galleryTitle.frames = Paths.getSparrowAtlas('FNF_main_menu_assets');
        galleryTitle.animation.addByPrefix('idle', "donate white", 12);
        galleryTitle.animation.play('idle');
        galleryTitle.setGraphicSize(Std.int(galleryTitle.width * 0.5), 0);
        galleryTitle.updateHitbox();
        galleryTitle.antialiasing = true;
        add(galleryTitle);

        FlxG.sound.playMusic(Paths.music('9_-_The_Gallery'));
        // Conductor.changeBPM(71);
    }

    override function update(elapsed:Float)
    {
        if (movedBack) {
            super.update(elapsed);
            return;
        }

        if (controls.BACK && !movedBack)
        {
            FlxG.sound.music.stop();
            FlxG.sound.play(Paths.sound('cancelMenu'));
            movedBack = true;
            FlxG.switchState(new MainMenuState());
        }

        var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

        if (controls.LEFT || (gamepad != null && gamepad.pressed.DPAD_LEFT))
            leftArrow.animation.play('press');
        else
            leftArrow.animation.play('idle');
        
        if (controls.RIGHT || (gamepad != null && gamepad.pressed.DPAD_RIGHT))
            rightArrow.animation.play('press');
        else
            rightArrow.animation.play('idle');

        if (controls.LEFT_P || (gamepad != null && gamepad.justPressed.DPAD_LEFT)) {
            changeItem(-1);
        }
        if (controls.RIGHT_P || (gamepad != null && gamepad.justPressed.DPAD_RIGHT)) {
            changeItem(1);
        }

        super.update(elapsed);
    }

    private function changeItem(increment) {
        curIdx = FlxMath.wrap(curIdx + increment, 0, images.length - 1);

        for (i in 0...images.length) {
            dropShadow.visible = (curIdx < 3);
            images[i].visible = (i == curIdx);
        }

        descText.text = imageDescs[curIdx];
        descText.screenCenter(X);

        FlxG.sound.play(Paths.sound('scrollMenu'));
    }
}