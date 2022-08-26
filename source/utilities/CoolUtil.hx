package utilities;

import openfl.utils.Function;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import lime.app.Application;
import flixel.FlxG;
import states.PlayState;
import lime.utils.Assets;

using StringTools;

class CoolUtil
{
	public static var difficultyArray:Array<String> = ['EASY', "NORMAL", "HARD"];

	public static function difficultyString():String
		return difficultyArray[PlayState.storyDifficulty];

	public static function boundTo(value:Float, min:Float, max:Float):Float
	{
		var newValue:Float = value;

		if (newValue < min)
			newValue = min;
		else if (newValue > max)
			newValue = max;

		return newValue;
	}

	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = Assets.getText(path).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	public static function coolTextFileOfArrays(path:String, ?delimeter:String = " "):Array<Array<String>>
	{
		var daListOg = coolTextFile(path);

		var daList:Array<Array<String>> = [];

		for (line in daListOg)
		{
			daList.push(line.split(delimeter));
		}

		return daList;
	}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];

		for (i in min...max)
			dumbArray.push(i);

		return dumbArray;
	}

	public static function openURL(url:String)
	{
		#if linux
		Sys.command('/usr/bin/xdg-open', [url, "&"]);
		#else
		FlxG.openURL(url);
		#end
	}

	public static function coolTextCase(text:String):String
	{
		var returnText:String = "";

		var textArray:Array<String> = text.split(" ");

		for (text in textArray)
		{
			var textStuffs = text.split("");

			for (i in 0...textStuffs.length)
			{
				if (i != 0)
					returnText += textStuffs[i].toLowerCase();
				else
					returnText += textStuffs[i].toUpperCase();
			}

			returnText += " ";
		}

		return returnText;
	}

	// stolen from psych lmao cuz i'm lazy
	public static function dominantColor(sprite:flixel.FlxSprite):Int
	{
		var countByColor:Map<Int, Int> = [];

		for (col in 0...sprite.frameWidth)
		{
			for (row in 0...sprite.frameHeight)
			{
				var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);

				if (colorOfThisPixel != 0)
				{
					if (countByColor.exists(colorOfThisPixel))
						countByColor[colorOfThisPixel] = countByColor[colorOfThisPixel] + 1;
					else if (countByColor[colorOfThisPixel] != 13520687 - (2 * 13520687))
						countByColor[colorOfThisPixel] = 1;
				}
			}
		}

		var maxCount = 0;
		var maxKey:Int = 0; // after the loop this will store the max color

		countByColor[flixel.util.FlxColor.BLACK] = 0;

		for (key in countByColor.keys())
		{
			if (countByColor[key] >= maxCount)
			{
				maxCount = countByColor[key];
				maxKey = key;
			}
		}

		return maxKey;
	}

	/**
		Funny handler for `Application.current.window.alert` that *doesn't* crash on Linux and shit.

		@param message Message of the error.
		@param title Title of the error.

		@author Leather128
	**/
	public static function coolError(message:Null<String> = null, title:Null<String> = null):Void
	{
		#if !linux
		Application.current.window.alert(message, title);
		#else
		trace(title + " - " + message, ERROR);

		var text:FlxText = new FlxText(8, 0, 1280, title + " - " + message, 24);
		text.color = FlxColor.RED;
		text.borderSize = 1.5;
		text.borderStyle = OUTLINE;
		text.borderColor = FlxColor.BLACK;
		text.scrollFactor.set();
		text.cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		FlxG.state.add(text);

		FlxTween.tween(text, {alpha: 0, y: 8}, 5, {
			onComplete: function(_)
			{
				FlxG.state.remove(text);
				text.destroy();
			}
		});
		#end
	}

	/**
		Simple map that contains useful ascii color strings
		that can be used when printing to console for nice colors.

		@author martinwells (https://gist.github.com/martinwells/5980517)
	**/
	public static var ascii_colors:Map<String, String> = [
		'black' => '\033[0;30m',
		'red' => '\033[31m',
		'green' => '\033[32m',
		'yellow' => '\033[33m',
		'blue' => '\033[1;34m',
		'magenta' => '\033[1;35m',
		'cyan' => '\033[0;36m',
		'grey' => '\033[0;37m',
		'white' => '\033[1;37m',
		'default' => '\033[0;37m' // grey apparently
	];

	/**
		Used to replace haxe.Log.trace

		@param value Value to trace.
		@param pos_infos (Optional) Info about where the trace came from and parameters for it.

		@author Leather128
	**/
	public static function haxe_print(value:Dynamic, ?pos_infos:haxe.PosInfos):Void
	{
		if (pos_infos.customParams == null)
			print(value, null, pos_infos);
		else
		{
			var type:PrintType = pos_infos.customParams.copy()[0];
			pos_infos.customParams = null; // so no stupid shit in the end of prints :D
			print(Std.string(value), type, pos_infos);
		}
	}

	/**
		Prints the specified `message` with `type` and `pos_infos`.

		@param message The message to print as a `String`.
		@param type (Optional) The type of print (aka, `LOG`, `DEBUG`, `WARNING`, or `ERROR`) as a `PrintType`.
		@param pos_infos (Optional) Info about where the print came from.

		@author Leather128
	**/
	public static function print(message:String, ?type:PrintType = DEBUG, ?pos_infos:haxe.PosInfos):Void
	{
		switch (type)
		{
			case LOG:
				haxe_trace('${ascii_colors["default"]}[LOG] $message', pos_infos);
			case DEBUG:
				haxe_trace('${ascii_colors["green"]}[DEBUG] ${ascii_colors["default"]}$message', pos_infos);
			case WARNING:
				haxe_trace('${ascii_colors["yellow"]}[WARNING] ${ascii_colors["default"]}$message', pos_infos);
			case ERROR:
				haxe_trace('${ascii_colors["red"]}[ERROR] ${ascii_colors["default"]}$message', pos_infos);
			// if you really want null, then here have it >:(
			default:
				haxe_trace(message, pos_infos);
		}
	}

	/**
		Access to the old `haxe.Log.trace` function.

		@author Leather128
	**/
	public static var haxe_trace:Function;
}

enum PrintType
{
	LOG;
	DEBUG;
	WARNING;
	ERROR;
}