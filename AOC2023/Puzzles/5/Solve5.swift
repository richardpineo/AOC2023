
import AOCLib
import Foundation
import RegexBuilder

class Solve5: PuzzleSolver {
	func solveAExamples() -> Bool {
		solveA("Example5") == 35
	}

	func solveBExamples() -> Bool {
		solveB("Example5") == 0
	}

	var answerA = "0"
	var answerB = "0"

	func solveA() -> String {
		solveA("Input5").description
	}

	func solveB() -> String {
		solveB("Input5").description
	}

	func solveA(_ filename: String) -> Int {
		let almanac = load(filename)
		return 0
	}

	func solveB(_: String) -> Int {
		return 0
	}

	struct Almanac {
		var seeds: [Int]

		struct Map {
			var sourceName: String
			var destName: String

			struct Entry {
				var source: Int
				var dest: Int
				var length: Int
			}

			var entries: [Entry]
		}

		var maps: [Map]
	}

	func load(_ filename: String) -> Almanac {
		let lines = FileHelper.load(filename)!.filter { !$0.isEmpty }
		// seeds: 79 14 55 13
		let seeds: [Int] = lines[0]
			.subString(start: 7, count: lines[0].count - 7)
			.split(separator: " ")
			.map { Int($0)! }

		let mapDescription = Regex {
			Capture {
				OneOrMore(.word)
			}
			One("-to-")
			Capture {
				OneOrMore(.word)
			}
		}

		var index = 1
		var maps: [Almanac.Map] = []
		while index < lines.count {
			guard let mapNames = lines[index].firstMatch(of: mapDescription) else {
				break
			}
			index += 1
			var entries: [Almanac.Map.Entry] = []
			while index < lines.count {
				let values: [Int] = lines[index].split(separator: " ").compactMap { Int($0) }
				if values.count != 3 {
					break
				}
				entries.append(.init(source: values[0], dest: values[1], length: values[2]))
				index += 1
			}
			maps.append(.init(sourceName: String(mapNames.output.1), destName: String(mapNames.output.2), entries: entries))
		}

		return .init(seeds: seeds, maps: maps)
	}
}
