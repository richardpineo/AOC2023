
import AOCLib
import Foundation

class Solve1: PuzzleSolver {
	func solveAExamples() -> Bool {
		solveA("Example1") == 142
	}

	func solveBExamples() -> Bool {
		solveB("Example1b") == 281
	}

	var answerA = "55607"
	var answerB = "55291"

	func solveA() -> String {
		solveA("Input1").description
	}

	func solveB() -> String {
		solveB("Input1").description
	}

	func solveA(_ fileName: String) -> Int {
		let lines = FileHelper.load(fileName)!.filter { !$0.isEmpty }
		let numbers = lines.map {
			let firstDigit = $0.first { $0.isNumber }
			let lastDigit = $0.last { $0.isNumber }
			return Int(String(firstDigit!))! * 10 + Int(String(lastDigit!))!
		}
		return numbers.reduce(0, +)
	}

	let numbers: [String: Int] = [
		"1": 1,
		"2": 2,
		"3": 3,
		"4": 4,
		"5": 5,
		"6": 6,
		"7": 7,
		"8": 8,
		"9": 9,
		"one": 1,
		"two": 2,
		"three": 3,
		"four": 4,
		"five": 5,
		"six": 6,
		"seven": 7,
		"eight": 8,
		"nine": 9,
	]
	struct Found {
		var number: Int
		var distance: Int
	}

	func firstNumber(_ s: String, fromEnd: Bool) -> Int {
		let lowest: Found = numbers.reduce(.init(number: 0, distance: Int.max)) {
			var distance: Int?
			let indices = s.indices(of: $1.key)
			if fromEnd {
				let distances = indices.map { s.distance(from: $0, to: s.endIndex) }
				distance = distances.min()
			} else {
				let distances = indices.map { s.distance(from: s.startIndex, to: $0) }
				distance = distances.min()
			}
			guard let distance = distance else {
				return $0
			}
			if $0.distance < distance {
				return $0
			}
			return .init(number: $1.value, distance: distance)
		}
		return lowest.number
	}

	func solveB(_ fileName: String) -> Int {
		let lines = FileHelper.load(fileName)!.filter { !$0.isEmpty }
		let numbers = lines.map {
			let firstDigit = firstNumber($0, fromEnd: false)
			let lastDigit = firstNumber($0, fromEnd: true)
			return Int(String(firstDigit))! * 10 + Int(String(lastDigit))!
		}
		return numbers.reduce(0, +)
	}
}
