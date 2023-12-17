
import AOCLib
import Foundation
import RegexBuilder

class Solve8: PuzzleSolver {
	func solveAExamples() -> Bool {
		solveA("Example8") == 6
	}

	func solveBExamples() -> Bool {
		solveB("Example8b") == 6
	}

	var answerA = "17287"
	var answerB = "18625484023687"

	func solveA() -> String {
		solveA("Input8").description
	}

	func solveB() -> String {
		solveB("Input8").description
	}

	func solveA(_ filename: String) -> Int {
		let network = load(filename)
		return network.walk()
	}

	func solveB(_ filename: String) -> Int {
		let network = load(filename)
		return network.ghostWalk()
	}

	struct Network {
		enum Instruction {
			case left
			case right
		}

		var instructions: [Instruction]

		func instruction(for step: Int) -> Instruction {
			return instructions[step % instructions.count]
		}

		struct Node {
			var left: String
			var right: String
		}

		var nodes: [String: Node]

		func walk() -> Int {
			var step = 0
			var node = "AAA"
			while node != "ZZZ" {
				let found = nodes[node]!
				if instruction(for: step) == .left {
					node = found.left
				} else {
					node = found.right
				}
				step = step + 1
			}
			return step
		}

		var startingGhostNodes: [String] {
			nodes.keys.filter { $0.last! == "A" }
		}

		func ghostExit(node: String) -> Bool {
			node.last == "Z"
		}

		func takeStep(node: String, step: Int) -> String {
			let found = nodes[node]!
			if instruction(for: step) == .left {
				return found.left
			} else {
				return found.right
			}
		}

		struct Crumb: Hashable {
			var node: String
			var step: Int
		}

		func ghostWalkCycle(for startingNode: String) -> Int {
			var crumbs: Set<Crumb> = .init()
			crumbs.insert(.init(node: startingNode, step: 0))

			var step = 1
			var node = takeStep(node: startingNode, step: 0)
			while !crumbs.contains(.init(node: node, step: step % instructions.count)) {
				crumbs.insert(.init(node: node, step: step % instructions.count))

				if ghostExit(node: node) {
					return step
				}
				node = takeStep(node: node, step: step)
				step = step + 1
			}
			return step
		}

		func ghostWalk() -> Int {
			let exitCounts = startingGhostNodes.map { node in
				ghostWalkCycle(for: node)
			}
			let steps = Int(MathHelper.lcm(of: exitCounts))
			return steps
		}
	}

	func load(_ filename: String) -> Network {
		let lines = FileHelper.load(filename)!.filter { !$0.isEmpty }
		let instructions: [Network.Instruction] = lines[0].map {
			$0 == "R" ? .right : .left
		}

		// BBB = (DDD, EEE)
		let nodeEx = Regex {
			Capture { OneOrMore(.word) }
			One(" = (")
			Capture { OneOrMore(.word) }
			One(", ")
			Capture { OneOrMore(.word) }
			One(")")
		}

		var nodes: [String: Network.Node] = [:]
		lines.dropFirst().forEach {
			let nodeMatch = $0.firstMatch(of: nodeEx)!
			nodes[String(nodeMatch.1)] = .init(left: String(nodeMatch.2), right: String(nodeMatch.3))
		}
		return .init(instructions: instructions, nodes: nodes)
	}
}
