
import AOCLib
import Foundation

class Solve15: PuzzleSolver {
	func solveAExamples() -> Bool {
		solveA("Example15") == 1320
	}

	func solveBExamples() -> Bool {
		solveB("Example15") == 145
	}

	var answerA = "518107"
	var answerB = "303404"

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

	struct Lens {
		var label: String
		var focal: Int
	}

	func solveB(_ filename: String) -> Int {
		let raw = FileHelper.load(filename)!
			.filter { !$0.isEmpty }
			.first!
		let commands = raw.split(separator: ",").map(String.init)

		var boxes: [[Lens]] = .init(repeating: [], count: 256)

		commands.forEach { command in
			if command.last! == "-" {
				let label = command.subString(start: 0, count: command.count - 1)
				let boxIndex = applyHash(label)
				var box = boxes[boxIndex]
				let found = box.firstIndex {
					$0.label == label
				}
				if let found = found {
					box.remove(at: found)
				}
				boxes[boxIndex] = box
			} else {
				let focal = Int(String(command.last!))!
				let label = command.subString(start: 0, count: command.count - 2)
				let boxIndex = applyHash(label)
				var box = boxes[boxIndex]
				let found = box.firstIndex {
					$0.label == label
				}
				if let found = found {
					box[found].focal = focal
				} else {
					box.append(.init(label: label, focal: focal))
				}
				boxes[boxIndex] = box
			}
		}

		var power = 0
		boxes.enumerated().forEach { box in
			box.element.enumerated().forEach { lens in
				let lensPower =
					(box.offset + 1) *
					(lens.offset + 1) *
					(lens.element.focal)
				power = power + lensPower
			}
		}

		return power
	}
}
