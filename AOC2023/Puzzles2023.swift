
import AOCLib
import SwiftUI

class Puzzles2023: PuzzlesRepo {
	init() {
		let year = 2023

		puzzles = Puzzles(puzzles: [
			Puzzle(year: year, id: 1, name: "Trebuchet?!") { Solve1() },
			Puzzle(year: year, id: 2, name: "Cube Conundrum") { Solve2() },
			Puzzle(year: year, id: 3, name: "Gear Ratios") { Solve3() },
			Puzzle(year: year, id: 4, name: "Scratchcards") { Solve4() },
		])
	}

	var title: String {
		"Advent of Code 2023"
	}

	var puzzles: Puzzles

	func hasDetails(id _: Int) -> Bool {
		false
	}

	@ViewBuilder
	func details(id _: Int) -> some View {
		EmptyView()
	}
}
