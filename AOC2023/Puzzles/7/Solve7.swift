
import AOCLib
import Foundation
import RegexBuilder

class Solve7: PuzzleSolver {
	func solveAExamples() -> Bool {
		solveA("Example7") == 0
	}

	func solveBExamples() -> Bool {
		solveB("Example7") == 0
	}

	var answerA = "0"
	var answerB = "0"

	func solveA() -> String {
		solveA("Input7").description
	}

	func solveB() -> String {
		solveB("Input7").description
	}

	func solveA(_ filename: String) -> Int {
		let game = load(filename)
		return 0
	}

	func solveB(_: String) -> Int {
		return 0
	}

	struct Game {
		struct Hand {
			var cards: [Int]
			var bid: Int
		}

		var hands: [Hand]
	}

	func convert(_ s: String) -> Int {
		let c = s.character(at: 0)
		if c.isNumber {
			return Int(String(c))!
		}
		switch c {
		case "T": return 10
		case "J": return 11
		case "Q": return 12
		case "K": return 13
		case "A": return 14
		default: return -666
		}
	}

	func load(_ filename: String) -> Game {
		let lines = FileHelper.load(filename)!.filter { !$0.isEmpty }

		let handEx = Regex {
			Capture { One(.word.union(.digit)) }
			Capture { One(.word.union(.digit)) }
			Capture { One(.word.union(.digit)) }
			Capture { One(.word.union(.digit)) }
			Capture { One(.word.union(.digit)) }
			One(" ")
			Capture {
				OneOrMore(.digit)
			}
		}

		let hands: [Game.Hand] = lines.map {
			let handMatch = $0.firstMatch(of: handEx)!
			return .init(cards: [
				convert(String(handMatch.output.1)),
				convert(String(handMatch.output.2)),
				convert(String(handMatch.output.3)),
				convert(String(handMatch.output.4)),
				convert(String(handMatch.output.5)),
			],
			bid: Int(String(handMatch.output.6))!)
		}
		return .init(hands: hands)
	}
}
