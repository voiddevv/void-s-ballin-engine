package game.base;

typedef RatingData =
{
	var time:Float;
	var ratingName:String;
}

class Rating
{
	static var Times:Array<RatingData> = [
		{time: 45, ratingName: "sick"},
		{time: 90, ratingName: "good"},
		{time: 135, ratingName: "bad"},
		{time: 180, ratingName: "shit"}
	];

	public static function getFromNote(note:Note):String
	{
		for (rating in Times)
		{
			if (Math.abs(rating.time) >= Math.abs(Conductor.songPosition - note.strumTime))
				return rating.ratingName;
		}
		return "shit";
	}
}
