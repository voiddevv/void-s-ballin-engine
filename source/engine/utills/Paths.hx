package engine.utills;

import sys.FileSystem;

class Paths
{
	public static function getPath(path:String)
	{
		return FileSystem.absolutePath('assets/$path');
	}

	public static function image(path:String)
	{
		return getPath('images/$path.png');
	}

	public static function music(path:String)
	{
		return getPath('music/$path.ogg');
	}

	public static function sound(path:String)
	{
		return getPath('sound/$path.ogg');
	}

	public static function json(path:String)
	{
		return getPath('$path.json');
	}

	public static function inst(song:String)
	{
		return getPath('songs/$song/Inst.ogg');
	}

	public static function voice(song:String)
	{
		return getPath('songs/$song/Voices.ogg');
	}
	public static function getCharacter(name:String) {
		return getPath('images/characters/$name/char.png');
	}
}
