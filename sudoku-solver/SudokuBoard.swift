//
//  sudoku.swift
//  sudoku-solver
//
//  Created by Sebastian Bauer on 05.12.19.
//  Copyright © 2019 Sebastian Bauer. All rights reserved.
//

import Foundation

struct SudokuBoard {
	
	let values: [Int]
	
	init(values: [Int]) {
		
		self.values = values
		
	}
	
	func set(_ field: Int, to: Int) -> SudokuBoard {
		var newValues = values
		newValues[field] = to
		return SudokuBoard(values: newValues)
	}
	
	func isDone() -> Bool {
		return isConsisten() && !values.contains(0)
	}
	
	func isConsisten() -> Bool {
		var result = true
		for i in 0..<9 {
			result = result && isConsistent(row: i)
			result = result && isConsistent(column: i)
			result = result && isConsistent(square: i)
		}
		
		return result
	}
	
	private func isConsistent(row: Int) -> Bool {
		guard row >= 0 && row < 9 else { return false }
		
		for (i, check) in values[row*9..<(row+1)*9].enumerated() {
			for j in i+1..<9 {
				if values[row * 9 + j] != 0 && values[row * 9 + j] == check {
					return false
				}
			}
		}
		
		return true
	}
	
	private func isConsistent(column: Int) -> Bool {
		guard column >= 0 && column < 9 else { return false }
		
		for i in stride(from: column, to: 81, by: 9) {
			let check = values[i]
			for j in i/9+1..<9 {
				if values[column + j * 9] != 0 && values[column + j * 9] == check {
					return false
				}
			}
		}
		
		return true
	}
	
	private func isConsistent(square: Int) -> Bool {
		guard square >= 0 && square < 9 else { return false }
		
		let startIndex = (square / 3) * 27 + (square % 3) * 3
		
		for i in 0..<8 {
			let check = values[startIndex + (i % 3) + (i / 3) * 9]
			for j in i+1..<9 {
				if values[startIndex + (j % 3) + (j / 3) * 9] != 0
					&& values[startIndex + (j % 3) + (j / 3) * 9] == check {
					return false
				}
			}
		}
		
		return true
	}
}

extension SudokuBoard: CustomStringConvertible {
	
	var description: String {
		get {
			var result = ""
			for i in 0..<9 {
				for j in 0..<9 {
					result.append("\(values[i * 9 + j])")
				}
				result.append("\n")
			}
			return result
		}
	}
	
}
