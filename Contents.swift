//: # Edit SRT subtitles
import Foundation
//: Change `"some subtitle.srt"` to the path to your subtitle file
let oldFile = try String(contentsOfFile: "some subtitle.srt")

let chunks = oldFile.components(separatedBy: "\r\n\r\n")

let lastTitle = chunks.last!.components(separatedBy: "\r\n")[1].timecode(at:0)
let factor = Timecode(hour: 0, minute: 46, second: 5, millisecond: 300) / lastTitle

let strechedChunks = chunks.map { chunk -> String in
	var line = chunk.components(separatedBy: "\r\n")
	let timeline = line[1]
	let start = timeline.timecode(at: 0)
	let end = timeline.timecode(at: 17)
	line[1] = "\(start * factor) --> \(end * factor)"
	return line.joined(separator: "\r\n")
}

try strechedChunks.joined(separator: "\r\n\r\n").write(toFile: "/tmp/subtitles.srt", atomically: true, encoding: .utf8)
