
import AOCLib
import Foundation

class Solve6: PuzzleSolver {
	func solveAExamples() -> Bool {
		solveA(races: Self.example) == 288
	}

	func solveBExamples() -> Bool {
		solveB(race: Self.exampleB) == 71503
	}

	var answerA = "4403592"
	var answerB = "38017587"

	struct Race {
		var time: Int
		var record: Int

		func distance(_ held: Int) -> Int {
			let timeToMove = time - held
			let velocity = held
			return timeToMove * velocity
		}

		var numberBeatingRecord: Int {
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
	private static let exampleB: Race = .init(time: 71530, record: 940_200)

	// Time:        49     97     94     94
	// Distance:   263   1532   1378   1851
	private static let actual: [Race] = [
		.init(time: 49, record: 263),
		.init(time: 97, record: 1532),
		.init(time: 94, record: 1378),
		.init(time: 94, record: 1851),
	]
	private static let actualB: Race = .init(time: 49_979_494, record: 263_153_213_781_851)

	func solveA() -> String {
		solveA(races: Self.actual).description
	}

	func solveB() -> String {
		solveB(race: Self.actualB).description
	}

	func solveA(races: [Race]) -> Int {
		let score = races.reduce(1) {
			$0 * $1.numberBeatingRecord
		}
		return score
	}

	func solveB(race: Race) -> Int {
		var minVal = 0
		for t in 0 ... race.time {
			if race.distance(t) > race.record {
				minVal = t
				break
			}
		}
		var maxVal = 0
		for t in 0 ... race.time {
			if race.distance(race.time - t) > race.record {
				maxVal = race.time - t
				break
			}
		}
		return maxVal - minVal + 1
	}
}
