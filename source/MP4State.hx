package;

import polymod.format.ParseRules.PlainTextParseFormat;
#if windows
import Discord.DiscordClient;
#end
import flixel.util.FlxColor;
import openfl.Lib;
import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;

class MP4State extends FlxUIState
{
    public static var videoName:String = 'BogusOpening';
    public static var transToPlayState:Bool = true;

    override function create()
    {
        #if windows
		DiscordClient.changePresence("Watching a Cutscene", null);
		#end

        var video:MP4Handler = new MP4Handler();
        var state:MusicBeatState;

        if (transToPlayState)
            state = new PlayState();
        else {
            // FlxG.sound.playMusic(Paths.musicWithExtension('Title', "wav"));
            // Conductor.changeBPM(102);
            state = new StoryMenuState();
        }

        video.playMP4(Paths.video(videoName), state);
    }
}