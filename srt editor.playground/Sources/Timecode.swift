import Foundation

public let linebreak = "\r\n"
public let emptyLine = linebreak + linebreak

let secondInMilliseconds = UInt(1000)
let minuteInMilliseconds = 60 * secondInMilliseconds
let hourInMilliseconds = 60 * minuteInMilliseconds

public struct Timecode: CustomStringConvertible {
	let hour: UInt8
	let minute: UInt8
	let second: UInt8
	let millisecond: UInt16
	
	public init(hour: UInt8, minute: UInt8, second: UInt8, millisecond: UInt16) {
		(self.hour, self.minute, self.second, self.millisecond) = (hour, minute, second, millisecond)
	}
	
	init(milliseconds: UInt) {
		millisecond = UInt16(milliseconds % secondInMilliseconds)
		second = UInt8((milliseconds % minuteInMilliseconds) / secondInMilliseconds)
		minute = UInt8((milliseconds % hourInMilliseconds) / minuteInMilliseconds)
		hour = UInt8(milliseconds / hourInMilliseconds)
	}
	
	public var description: String {
		return String(format: "%02d", hour) + ":" +
			String(format: "%02d", minute) + ":" +
			String(format: "%02d", second) + "," +
			String(format: "%03d", millisecond)
	}
	
	var milliseconds: UInt {
		return UInt(hour) * hourInMilliseconds +
			UInt(minute) * minuteInMilliseconds +
			UInt(second) * secondInMilliseconds +
			UInt(millisecond)
	}
	
	public static func * (time: Timecode, factor: Double) -> Timecode {
		return Timecode(milliseconds: UInt(Double(time.milliseconds) * factor))
	}
	
	public static func / (left: Timecode, right: Timecode) -> Double {
		return Double(left.milliseconds) / Double(right.milliseconds)
	}
}

extension String {
	public func timecode(at base: Int) -> Timecode {
		return Timecode(hour: UInt8(self[index(startIndex, offsetBy: base) ..< index(startIndex, offsetBy: base+2)])!,
		                minute: UInt8(self[index(startIndex, offsetBy: base+3) ..< index(startIndex, offsetBy: base+5)])!,
		                second: UInt8(self[index(startIndex, offsetBy: base+6) ..< index(startIndex, offsetBy: base+8)])!,
		                millisecond: UInt16(self[index(startIndex, offsetBy: base+9) ..< index(startIndex, offsetBy: base + 12)])!
		)
	}
}
