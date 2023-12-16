
import AOCLib
import Foundation

class Solve6: PuzzleSolver {
	func solveAExamples() -> Bool {
		solveA(races: Self.example) == 288
	}

	func solveBExamples() -> Bool {
		solveB("Example6") == 0
	}

	var answerA = "4403592"
	var answerB = "0"
	
	struct Race {
		var time: Int
		var record: Int
		
		func distance(_ held: Int) -> Int {
			let timeToMove = time - held
			let velocity = held
			return timeToMove * velocity
		}
		
		var  beatsRecord: Int {
			(0 ... time).filter {
				distance($0) > record
			}
			.count
		}
	}
	
	// Time:      7  15   30
	// Distance:  9  40  200
	private static let example: [Race] = [
		.init(time: 7, record: 9),
		.init(time: 15, record: 40),
		.init(time: 30, record: 200),
	]

	// Time:        49     97     94     94
	// Distance:   263   1532   1378   1851
	private static let actual: [Race] = [
		.init(time: 49, record: 263),
		.init(time: 97, record: 1532),
		.init(time: 94, record: 1378),
		.init(time: 94, record: 1851),
	]

	func solveA() -> String {
		solveA(races: Self.actual).description
	}

	func solveB() -> String {
		solveB("Input6").description
	}

	func solveA(races: [Race]) -> Int {
		let score = races.reduce(1) {
			$0 * $1.beatsRecord
		}
		return score
	}

	func solveB(_: String) -> Int {
		return 0
	}
}
