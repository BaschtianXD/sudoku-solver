//
//  Solver.swift
//  sudoku-solver
//
//  Created by Sebastian Bauer on 12.12.19.
//  Copyright © 2019 Sebastian Bauer. All rights reserved.
//

import Foundation

class Solver {
	
	private let board: SudokuBoard
	
	private var options: [[Bool]]
	private var working: [Int]
	
	init(sudoku: SudokuBoard) {
		board = sudoku
		working = board.values
		
		options = Array(repeating: Array(repeating: true, count: 9), count: 81)
	}
	
	private init(sudoku: SudokuBoard, options: [[Bool]]) {
		board = sudoku
		self.options = options
		working = board.values
	}
	
	func solve() -> SudokuBoard {
		
		for i in 0..<81 {
			if working[i] != 0 {
				options[i] = Array(repeating: false, count: 9)
				updateOptionsFor(field: i)
			}
		}
		
		var somethingdone = true
		
		solverloop: while working.contains(0) && somethingdone {
			
			if !hasOptionsLeft() {
				return SudokuBoard(values: working)
			}
			
			somethingdone = false
			
			//check if there is a field in which we can only put a single number
			for (field, fieldoptions) in options.enumerated() {
				if fieldoptions.reduce(0, { (acc, option) in
					return option ? acc + 1 : acc
				}) == 1 {
					working[field] = fieldoptions.firstIndex(where: { $0 })! + 1
					options[field] = Array(repeating: false, count: 9)
					updateOptionsFor(field: field)
					somethingdone = true
					print("Set field \(field) to value \(working[field])")
					continue solverloop
				}
			}
			
			for i in 0..<9 {
				//rows
				var values = Array(repeating: checks.none, count: 9)
				for j in 0..<9 {
					for n in 0..<9 {
						if options[i * 9 + j][n] {
							switch values[n] {
							case .none:
								values[n] = .one(j)
							case .one(_):
								values[n] = .multiple
							case .multiple:
								break
							}
						}
					}
				}
				
				for n in 0..<9 {
					if case let .one(j) = values[n] {
						let field = i * 9 + j
						working[field] = n + 1
						options[field] = Array(repeating: false, count: 9)
						updateOptionsFor(field: field)
						somethingdone = true
						print("Set field \(field) to value \(working[field])")
						continue solverloop
					}
				}
				
				//columns
				values = Array(repeating: checks.none, count: 9)
				
				for j in 0..<9 {
					for n in 0..<9 {
						if options[i + j * 9][n] {
							switch values[n] {
							case .none:
								values[n] = .one(j)
							case .one(_):
								values[n] = .multiple
							case .multiple:
								break
							}
						}
					}
				}
				
				for n in 0..<9 {
					if case let .one(j) = values[n] {
						let field = i + j * 9
						working[field] = n + 1
						options[field] = Array(repeating: false, count: 9)
						updateOptionsFor(field: field)
						somethingdone = true
						print("Set field \(field) to value \(working[field])")
						continue solverloop
					}
				}
				
				//squares
				values = Array(repeating: checks.none, count: 9)
				let startindex = (i % 3) * 3 + i / 3 * 27
				
				for j in 0..<9 {
					for n in 0..<9 {
						if options[startindex + (j % 3) + (j / 3) * 9][n] {
							switch values[n] {
							case .none:
								values[n] = .one(j)
							case .one(_):
								values[n] = .multiple
							case .multiple:
								break
							}
						}
					}
				}
				
				for n in 0..<9 {
					if case let .one(j) = values[n] {
						let field = startindex + (j % 3) + (j / 3) * 9
						working[field] = n + 1
						options[field] = Array(repeating: false, count: 9)
						updateOptionsFor(field: field)
						somethingdone = true
						print("Set field \(field) to value \(working[field])")
						continue solverloop
					}
				}
			}
			
			let lowesOptionIndex = options.enumerated()
				.map({ (index: $0.0, min: $0.1.count) })
				.reduce((index: 0, min: 10), { $0.min > $1.min ? $1 : $0 })
				.index
			
			for (index, option) in options[lowesOptionIndex].enumerated() {
				if option {
					var dec = working
					dec[lowesOptionIndex] = index + 1
					
					let decSolver = Solver(sudoku: SudokuBoard(values: dec))
					
					let decResult = decSolver.solve()
					
					if decResult.isDone() {
						return decResult
					}
				}
			}
		}
		
		
		return SudokuBoard(values: working)
	}
	
	private func updateOptionsFor(field: Int) {
		let row = field / 9
		let column = field % 9
		let tempsquare = ((field / 3) / 9) * 3 + (field / 3) % 3
		let square = (tempsquare / 3) * 27 + (tempsquare % 3) * 3
		
		let newValue = working[field]
		
		for i in 0..<9 {
			//row
			options[row * 9 + i][newValue-1] = false
			
			//column
			options[column + 9 * i][newValue-1] = false
			
			//square
			options[square + (i / 3) * 9 + i % 3][newValue-1] = false
		}
	}
	
	func hasOptionsLeft() -> Bool {
		
		// check if the board is still solvable
		for i in 0..<81 {
			if working[i] != 0 && options[i].count == 0 {
				return false
			}
		}
		
		return true
	}
	
	enum checks {
		case none
		case one(Int)
		case multiple
	}
}
