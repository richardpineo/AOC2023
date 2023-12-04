
import AOCLib
import Foundation

class Solve2: PuzzleSolver {
	func solveAExamples() -> Bool {
		solveA("Example2") == 8
	}

	func solveBExamples() -> Bool {
		solveB("Example2") == 2286
	}

	var answerA = "2913"
	var answerB = "55593"

	func solveA() -> String {
		solveA("Input2").description
	}

	func solveB() -> String {
		solveB("Input2").description
	}

	func solveA(_ filename: String) -> Int {
		let games = load(filename)
		let red = 12
		let green = 13
		let blue = 14
		let valid = games.filter {
			$0.subsets.allSatisfy {
				$0.red <= red && $0.green <= green && $0.blue <= blue
			}
		}
		return valid.map { $0.game }.reduce(0, +)
	}

	func solveB(_ filename: String) -> Int {
		let games = load(filename)
		let minimums = games.map { $0.minimum }
		let powers = minimums.map { $0.power }
		return powers.reduce(0, +)
	}

	struct Game {
		var game: Int
		struct Subset {
			var red: Int
			var green: Int
			var blue: Int
			var power: Int {
				red * green * blue
			}
		}
		var subsets: [Subset]

		var minimum: Subset {
			subsets.reduce(Subset(red: 0, green: 0, blue: 0)) {
				return .init(
					red: max($0.red, $1.red),
					green: max($0.green, $1.green),
					blue: max($0.blue, $1.blue))
			}
		}
	}
	
	func parseSubset(subset: String) -> Game.Subset {
		let tokens = subset.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }
		var red = 0
		var green = 0
		var blue = 0
		tokens.forEach { token in
			let parts = token.split(separator: " ")
			if parts.count != 2 {
				return
			}
			switch parts[1] {
			case "red": red = Int(parts[0])!
			case "green": green = Int(parts[0])!
			case "blue": blue = Int(parts[0])!
			default:
				return
			}
			
		}
		return .init(red: red, green: green, blue: blue)
	}
	
	func load(_ filename: String) -> [Game] {
		let lines = FileHelper.load(filename)!.filter { !$0.isEmpty }
		// Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
		return lines.map { line in
			let colonIndex = line.index(of: ":")!
			let colonPos = line.distance(from: line.startIndex, to: colonIndex)
			let gameNum = line.subString(start: 5, count: colonPos - 5)
			let subSets = line.subString(start: colonPos + 1, count: line.count - colonPos - 1).split(separator: ";").map { String($0).trimmingCharacters(in: .whitespaces) }
			return .init(game: Int(gameNum)!, subsets: subSets.map { parseSubset(subset: $0) } )
		}
	}
}
