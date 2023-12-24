
import AOCLib
import Foundation

class Solve15: PuzzleSolver {
	func solveAExamples() -> Bool {
		solveA("Example15") == 1320
	}

	func solveBExamples() -> Bool {
		solveB("Example15") == 0
	}

	var answerA = "518107"
	var answerB = "0"

	func solveA() -> String {
		solveA("Input15").description
	}

	func solveB() -> String {
		solveB("Input15").description
	}

	func applyHash(_ s: String) -> Int {
		s.reduce(0) {
			var next = $0 + Int($1.asciiValue!)
			next = next * 17
			next = next % 256
			return next
		}
	}

	func solveA(_ filename: String) -> Int {
		let raw = FileHelper.load(filename)!
			.filter { !$0.isEmpty }
			.first!
		let commands = raw.split(separator: ",").map(String.init)
		let hashed = commands.map(applyHash)
		return hashed.reduce(0, +)
	}

	func solveB(_: String) -> Int {
		return 0
	}
}
