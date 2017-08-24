//: # Strech SRT subtitles
//: Multiply all timecodes in a .srt file with some factor. This factor is calculated based on the difference between a timecode from a title in the srt file and the "real" timecode of the corresponding fragment in the movie.
import Foundation
//: To load the subtitle file:
//: change `"some subtitle.srt"` to the path to your subtitle file
let oldFile = try String(contentsOfFile: "some subtitle.srt")

let linebreak = "\r\n"
let emptyLine = linebreak + linebreak
let titles = oldFile.components(separatedBy: emptyLine)
//: Search the last spoken fragment in the movie and write down the timecode. Store this timecode in `adjustedTimecode`.
let adjustedTimecode = Timecode(hour: 0, minute: 46, second: 5, millisecond: 300)
let lastTimecode = titles.last!.components(separatedBy: linebreak)[1].timecode(at:0)
let factor = adjustedTimecode / lastTimecode

let strechedTitles = titles.map { title -> String in
	var line = title.components(separatedBy: linebreak)
	let timeLine = line[1]
	let start = timeLine.timecode(at: 0)
	let end = timeLine.timecode(at: 17)
	line[1] = "\(start * factor) --> \(end * factor)"
	return line.joined(separator: linebreak)
}

try strechedTitles.joined(separator: emptyLine).write(toFile: "/tmp/subtitles.srt", atomically: true, encoding: .utf8)
