
import AOCLib
import Foundation
import RegexBuilder

class Solve7: PuzzleSolver {
	func solveAExamples() -> Bool {
		solveA("Example7") == 6440
	}

	func solveBExamples() -> Bool {
		solveB("Example7") == 5905
	}

	var answerA = "251106089"
	var answerB = "0"

	func solveA() -> String {
		solveA("Input7").description
	}

	func solveB() -> String {
		solveB("Input7").description
	}

	func solveA(_ filename: String) -> Int {
		let game = load(filename)
		let sorted = game.sorted
//		let descriptions = sorted.map { "\($0.rank): \($0.stringForm)" }
//		print( descriptions.joined(separator: "\n"))
		var totalWinnings = 0
		for rank in 1 ... sorted.count {
			let winnings = sorted[rank - 1].bid * rank
			totalWinnings += winnings
		}
		return totalWinnings
	}

	func solveB(_: String) -> Int {
		return 0
	}

	struct Game {
		struct Hand {
			var stringForm: String
			var cards: [Int]
			var bid: Int

			var rawValue: Int {
				cards[0] * 10000 * 10000 +
					cards[1] * 1000 * 1000 +
					cards[2] * 100 * 100 +
					cards[3] * 10 * 10 +
					cards[4]
			}

			enum Rank: Int {
				case fiveOfAKind = 6
				case fourOfAKind = 5
				case fullHouse = 4
				case threeOfAKind = 3
				case twoPair = 2
				case onePair = 1
				case highCard = 0
			}

			var rank: Rank {
				let dict = cards.reduce([:]) { d, c -> [Int: Int] in
					var d = d
					let i = d[c] ?? 0
					d[c] = i + 1
					return d
				}
				let sorted = Array(dict.values.sorted().reversed())
				switch sorted.count {
				case 1:
					return .fiveOfAKind
				case 2:
					if sorted[0] == 4 {
						return .fourOfAKind
					}
					return .fullHouse
				case 3:
					if sorted[0] == 3 {
						return .threeOfAKind
					}
					return .twoPair
				case 4:
					return .onePair
				case 5:
					return .highCard
				default:
					return .highCard
				}
			}
		}

		var hands: [Hand]

		var sorted: [Hand] {
			hands.sorted {
				if $0.rank != $1.rank {
					return $0.rank.rawValue < $1.rank.rawValue
				}
				return $0.rawValue < $1.rawValue
			}
		}
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
			return .init(
				stringForm: $0,
				cards: [
					convert(String(handMatch.output.1)),
					convert(String(handMatch.output.2)),
					convert(String(handMatch.output.3)),
					convert(String(handMatch.output.4)),
					convert(String(handMatch.output.5)),
				],
				bid: Int(String(handMatch.output.6))!
			)
		}
		return .init(hands: hands)
	}
}
