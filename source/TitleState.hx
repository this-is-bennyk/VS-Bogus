package;

#if sys
import smTools.SMFile;
#end
import flash.system.System;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import openfl.Assets;

#if windows
import Discord.DiscordClient;
#end

#if cpp
import sys.thread.Thread;
#end

using StringTools;

class TitleState extends MusicBeatState
{
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;
	var callyTeamSprite:FlxSprite;

	var curWacky:Array<String> = [];

	override public function create():Void
	{
		#if polymod
		polymod.Polymod.init({modRoot: "mods", dirs: ['introMod']});
		#end
		
		#if sys
		if (!sys.FileSystem.exists(Sys.getCwd() + "/assets/replays"))
			sys.FileSystem.createDirectory(Sys.getCwd() + "/assets/replays");
		#end

		@:privateAccess
		{
			trace("Loaded " + openfl.Assets.getLibrary("default").assetsLoaded + " assets (DEFAULT)");
		}
		
		#if !cpp

		FlxG.save.bind('funkin', 'ninjamuffin99');

		PlayerSettings.init();

		KadeEngineData.initSave();
		
		#end

				
		Highscore.load();


		curWacky = FlxG.random.getObject(getIntroTextShit());

		trace('hello');

		// DEBUG BULLSHIT

		super.create();

		// NGio.noLogin(APIStuff.API);

		#if ng
		var ng:NGio = new NGio(APIStuff.API, APIStuff.EncKey);
		trace('NEWGROUNDS LOL');
		#end

		#if FREEPLAY
		FlxG.switchState(new FreeplayState());
		#elseif CHARTING
		FlxG.switchState(new ChartingState());
		#else
		#if !cpp
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			startIntro();
		});
		#else
		startIntro();
		#end
		#end
	}

	var logoBl:FlxSprite;
	var bogusWalkFG:FlxSprite;
	var bogusWalkBG:FlxSprite;
	var bogusWillNot:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	function startIntro()
	{
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		// bg.antialiasing = true;
		// bg.setGraphicSize(Std.int(bg.width * 0.6));
		// bg.updateHitbox();
		add(bg);

		logoBl = new FlxSprite().loadGraphic(Paths.image('vs_bogus_logo'), false);
		if(FlxG.save.data.antialiasing)
			{
				logoBl.antialiasing = true;
			}
		logoBl.screenCenter();
		logoBl.y -= FlxG.height * 0.1;

		bogusWalkFG = new FlxSprite();
		bogusWalkBG = new FlxSprite();

		bogusWalkFG.frames = Paths.getSparrowAtlas('BogusMenuWalk');
		bogusWalkBG.frames = Paths.getSparrowAtlas('BogusMenuWalk');
		
		bogusWalkFG.animation.addByPrefix('danceLeft', 'BogusMenuWalk idle', 15, false);
		bogusWalkFG.animation.addByPrefix('danceRight', 'BogusMenuWalk idle', 15, false, true);
		bogusWalkBG.animation.addByPrefix('danceLeft', 'BogusMenuWalk idle', 15, false);
		bogusWalkBG.animation.addByPrefix('danceRight', 'BogusMenuWalk idle', 15, false, true);

		bogusWalkFG.animation.finished = true;
		bogusWalkFG.antialiasing = true;
		bogusWalkFG.screenCenter();
		bogusWalkBG.animation.finished = true;
		bogusWalkBG.antialiasing = true;
		bogusWalkBG.screenCenter();

		add(bogusWalkBG);
		add(logoBl);

		titleText = new FlxSprite(135, FlxG.height * 0.75);
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		if(FlxG.save.data.antialiasing)
			{
				titleText.antialiasing = true;
			}
		titleText.animation.play('idle');
		titleText.updateHitbox();
		
		add(titleText);
		add(bogusWalkFG);

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
		logo.screenCenter();
		if(FlxG.save.data.antialiasing)
			{
				logo.antialiasing = true;
			}
		// add(logo);

		// FlxTween.tween(logoBl, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		// FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "ninjamuffin99\nPhantomArcade\nkawaisprite\nevilsk8er", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('newgrounds_logo'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		if(FlxG.save.data.antialiasing)
			{
				ngSpr.antialiasing = true;
			}
		
		callyTeamSprite = new FlxSprite(0, FlxG.height * 0.1, Paths.image('CallyTEEM'));
		add(callyTeamSprite);
		callyTeamSprite.visible = false;
		callyTeamSprite.setGraphicSize(Std.int(ngSpr.width * 3));
		callyTeamSprite.updateHitbox();
		callyTeamSprite.screenCenter(X);
		callyTeamSprite.antialiasing = true;

		bogusWillNot = new FlxSprite();
		bogusWillNot.frames = Paths.getSparrowAtlas('BogusWillNot');
		bogusWillNot.animation.addByPrefix('DIEBITCH', 'BogusWillNot idle', 60, false);
		bogusWillNot.antialiasing = true;
		bogusWillNot.visible = false;
		// bogusWillNot.y += 200;
		bogusWillNot.screenCenter();
		add(bogusWillNot);

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		FlxG.mouse.visible = false;

		if (initialized)
			skipIntro();
		else {
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

			// HAD TO MODIFY SOME BACKEND SHIT
			// IF THIS PR IS HERE IF ITS ACCEPTED UR GOOD TO GO
			// https://github.com/HaxeFlixel/flixel-addons/pull/348

			// var music:FlxSound = new FlxSound();
			// music.loadStream(Paths.music('freakyMenu'));
			// FlxG.sound.list.add(music);
			// music.play();
			FlxG.sound.playMusic(Paths.musicWithExtension('Title', "wav"), 0);

			FlxG.sound.music.fadeIn(4, 0, 0.7);
			Conductor.changeBPM(102);
			initialized = true;
		}

		// bogusTimer = new FlxTimer();
	}

	function logoBump(logo:FlxSprite, val:Float) {
		logo.scale.set(val, val);
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('data/introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;
	var bogusMoment:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		var pressedEnter:Bool = controls.ACCEPT;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		if (pressedEnter && !transitioning && skippedIntro)
		{
			#if !switch
			NGio.unlockMedal(60960);

			// If it's Friday according to da clock
			if (Date.now().getDay() == 5)
				NGio.unlockMedal(61034);
			#end

			if (FlxG.save.data.flashing)
				titleText.animation.play('press');

			FlxG.camera.flash(FlxColor.WHITE, 1);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

			transitioning = true;
			// FlxG.sound.music.stop();

			MainMenuState.firstStart = true;
			MainMenuState.finishedFunnyMove = false;

			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				FlxG.switchState(new MainMenuState());
				// // Get current version of Kade Engine
				
				// var http = new haxe.Http("https://raw.githubusercontent.com/KadeDev/Kade-Engine/master/version.downloadMe");
				// var returnedData:Array<String> = [];
				
				// http.onData = function (data:String)
				// {
				// 	returnedData[0] = data.substring(0, data.indexOf(';'));
				// 	returnedData[1] = data.substring(data.indexOf('-'), data.length);
				//   	if (!MainMenuState.kadeEngineVer.contains(returnedData[0].trim()) && !OutdatedSubState.leftState)
				// 	{
				// 		trace('outdated lmao! ' + returnedData[0] + ' != ' + MainMenuState.kadeEngineVer);
				// 		OutdatedSubState.needVer = returnedData[0];
				// 		OutdatedSubState.currChanges = returnedData[1];
				// 		FlxG.switchState(new OutdatedSubState());
				// 	}
				// 	else
				// 	{
				// 		FlxG.switchState(new MainMenuState());
				// 	}
				// }
				
				// http.onError = function (error) {
				//   trace('error: $error');
				//   FlxG.switchState(new MainMenuState()); // fail but we go anyway
				// }
				
				// http.request();
			});
			// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
		}

		if (pressedEnter && !skippedIntro && initialized)
		{
			skipIntro();
		}

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	var frontPlaying:Bool = false;

	override function beatHit()
	{
		super.beatHit();

		if (bogusMoment && !logoBl.visible) {
			return;
		}

		if ((frontPlaying && bogusWalkFG.animation.finished) || (!frontPlaying && bogusWalkBG.animation.finished)) {
			if (bogusMoment) {
				trace('IM GONNA DO IT');
				logoBl.visible = false;
				titleText.visible = false;
				bogusWalkBG.visible = false;
				bogusWalkFG.visible = false;
				FlxG.sound.music.stop();
				playCreepySound();
				return;
			}
			
			var animToPlay = '';
			if (danceLeft) {
				animToPlay = 'danceRight';
			} else {
				animToPlay = 'danceLeft';
			}

			if (frontPlaying)
				bogusWalkBG.animation.play(animToPlay);
			else
				bogusWalkFG.animation.play(animToPlay);

			danceLeft = !danceLeft;
			frontPlaying = FlxG.random.bool(50);
		}

		FlxTween.num(0.9, 0.8, 0.5, {ease: FlxEase.backIn, type: FlxTweenType.ONESHOT}, logoBump.bind(logoBl));

		FlxG.log.add(curBeat);

		switch (curBeat)
		{
			// still don't trust this
			case 0:
				deleteCoolText();
			case 1:
				callyTeamSprite.visible = true;
				createCoolText(['', 'Cally3D', 'Dod', 'McDoodle', 'Sayge', 'ThisIsBennyK']);
				// createCoolText(['ninjamuffin99', 'phantomArcade', 'kawaisprite', 'evilsk8er']);
			// credTextShit.visible = true;
			case 3:
				addMoreText('present');
			// credTextShit.text += '\npresent...';
			// credTextShit.addText();
			case 4:
				deleteCoolText();
				callyTeamSprite.visible = false;
			// credTextShit.visible = false;
			// credTextShit.text = 'In association \nwith';
			// credTextShit.screenCenter();
			case 5:
				if (Main.watermarks)
					createCoolText(['Kade Engine', 'by']);
				else
					createCoolText(['In Partnership', 'with']);
				// callyTeamSprite.visible = true;
				// createCoolText(['', 'Cally3D', 'Dod', 'McDoodle', 'Sayge', 'ThisIsBennyK']);
			case 7:
				if (Main.watermarks)
					addMoreText('KadeDeveloper');
				else
				{
					addMoreText('Newgrounds');
					ngSpr.visible = true;
				}
				// addMoreText('present');
			// credTextShit.text += '\nNewgrounds';
			case 8:
				deleteCoolText();
				// callyTeamSprite.visible = false;
				ngSpr.visible = false;
			// credTextShit.visible = false;

			// credTextShit.text = 'Shoutouts Tom Fulp';
			// credTextShit.screenCenter();
			case 9:
				createCoolText([curWacky[0]]);
			// credTextShit.visible = true;
			case 11:
				addMoreText(curWacky[1]);
			// credTextShit.text += '\nlmao';
			case 12:
				deleteCoolText();
			// credTextShit.visible = false;
			// credTextShit.text = "Friday";
			// credTextShit.screenCenter();
			case 13:
				addMoreText('VS');
			// credTextShit.visible = true;
			case 14:
				addMoreText('Redditor');
			// credTextShit.text += '\nNight';
			case 15:
				addMoreText('Bogus'); // credTextShit.text += '\nFunkin';

			case 16:
				skipIntro();
		}
	}

	var skippedIntro:Bool = false;
	var bogusTimer:FlxTimer;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);
			remove(callyTeamSprite);

			FlxG.camera.flash(FlxColor.WHITE, 4);
			remove(credGroup);
			skippedIntro = true;
			
			// if (bogusTimer == null)
			bogusTimer = new FlxTimer();
			bogusTimer.start(60, onScaryTimerCompleted);
		}
	}

	function onScaryTimerCompleted(tmr:FlxTimer) {
		trace('GET FUCKED!!!!!');
		bogusMoment = true;
	}

	function playCreepySound() {
		// :)
		trace('Phase 2');
		FlxG.sound.play(Paths.sound('smile'), 1);
		new FlxTimer().start(FlxG.random.float(5, 10), bogusKillsYou);
	}

	function bogusKillsYou(tmr:FlxTimer) {
		trace('Phase 3');
		bogusWillNot.visible = true;
		trace('bwn on screen: ' + bogusWillNot.isOnScreen(FlxG.camera));
		bogusWillNot.animation.play('DIEBITCH', true);
		new FlxTimer().start(0.5, exitGame);
	}

	function exitGame(tmr:FlxTimer) {
		System.exit(0);
	}
}
