
import AOCLib
import Foundation
import RegexBuilder

class Solve7: PuzzleSolver {
	func solveAExamples() -> Bool {
		solve("Example7", jokerRule: false) == 6440
	}

	func solveBExamples() -> Bool {
		solve("Example7", jokerRule: true) == 5905
	}

	var answerA = "251106089"
	var answerB = "249620106"

	func solveA() -> String {
		solve("Input7", jokerRule: false).description
	}

	func solveB() -> String {
		solve("Input7", jokerRule: true).description
	}

	func solve(_ filename: String, jokerRule: Bool) -> Int {
		let game = load(filename, jokerRule: jokerRule)
		let sorted = game.sorted
		//	let descriptions = sorted.map { "\($0.rank): \($0.stringForm)" }
		//	print( descriptions.joined(separator: "\n"))
		var totalWinnings = 0
		for rank in 1 ... sorted.count {
			let winnings = sorted[rank - 1].bid * rank
			totalWinnings += winnings
		}
		print("total: \(totalWinnings)")
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
			var jokerRule: Bool

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
				var dict = cards.reduce([:]) { d, c -> [Int: Int] in
					var d = d
					let i = d[c] ?? 0
					d[c] = i + 1
					return d
				}
				var numJokers = 0
				if jokerRule {
					if let js = dict[2] {
						if js < 5 {
							dict.removeValue(forKey: 2)
							numJokers = js
						}
					}
				}
				var sorted = Array(dict.values.sorted().reversed())
				sorted[0] = sorted[0] + numJokers
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

	func convert(_ s: String, jokerRule: Bool) -> Int {
		let raw = convert(s)
		if !jokerRule {
			return raw
		}
		if raw == 11 {
			return 2
		}
		return raw + 1
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

	func load(_ filename: String, jokerRule: Bool) -> Game {
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
					convert(String(handMatch.output.1), jokerRule: jokerRule),
					convert(String(handMatch.output.2), jokerRule: jokerRule),
					convert(String(handMatch.output.3), jokerRule: jokerRule),
					convert(String(handMatch.output.4), jokerRule: jokerRule),
					convert(String(handMatch.output.5), jokerRule: jokerRule),
				],
				bid: Int(String(handMatch.output.6))!,
				jokerRule: jokerRule
			)
		}
		return .init(hands: hands)
	}
}
