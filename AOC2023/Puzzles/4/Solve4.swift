
import AOCLib
import Foundation

class Solve4: PuzzleSolver {
	func solveAExamples() -> Bool {
		solveA("Example4") == 13
	}

	func solveBExamples() -> Bool {
		solveB("Example4") == 30
	}

	var answerA = "26346"
	var answerB = "8467762"

	func solveA() -> String {
		solveA("Input4").description
	}

	func solveB() -> String {
		solveB("Input4").description
	}

	func solveA(_ filename: String) -> Int {
		let cards = load(filename)
//		cards.forEach {
//			print ("Card \($0.number): \($0.numMatches) for \($0.points)")
//		}
		return cards.reduce(0) {
			$0 + $1.points
		}
	}

	func solveB(_ filename: String) -> Int {
		let cards = load(filename)
		var cardCount: [Int: Int] = [:]
		for number in 1 ... cards.count {
			cardCount[number] = 1
		}
		cards.forEach { card in
			for index in 0 ..< card.numMatches {
				cardCount[index + 1 + card.number]! += cardCount[card.number]!
			}
		}
		return cardCount.values.reduce(0, +)
	}

	struct Card {
		var number: Int
		var winners: [Int]
		var ours: [Int]

		var numMatches: Int {
			ours.filter {
				winners.contains($0)
			}.count
		}

		var points: Int {
			if numMatches == 0 {
				return 0
			}
			return lround(pow(2, Double(numMatches - 1)))
		}
	}

	func load(_ filename: String) -> [Card] {
		let lines = FileHelper.load(filename)!.filter { !$0.isEmpty }
		// Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
		return lines.map { line in
			let spaceIndex = line.index(of: " ")!.utf16Offset(in: line)
			let colonIndex = line.index(of: ":")!.utf16Offset(in: line)
			let cardNumberStr = line.subString(start: spaceIndex + 1, count: colonIndex - spaceIndex - 1)
			let cardNumber = Int(cardNumberStr.trimmingCharacters(in: CharacterSet.whitespaces))!

			let divIndex = line.index(of: "|")!.utf16Offset(in: line)
			let winners = line.subString(start: colonIndex + 2, count: divIndex - colonIndex - 3)
				.split(separator: " ")
				.map { Int($0)! }

			let endIndex = line.endIndex.utf16Offset(in: line)
			let ours = line.subString(start: divIndex + 2, count: endIndex - divIndex - 2)
				.split(separator: " ")
				.map { Int($0)! }

			return .init(number: cardNumber, winners: winners, ours: ours)
		}
	}
}
