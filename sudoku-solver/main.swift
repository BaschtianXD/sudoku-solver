//
//  main.swift
//  sudoku-solver
//
//  Created by Sebastian Bauer on 05.12.19.
//  Copyright © 2019 Sebastian Bauer. All rights reserved.
//

import Foundation

print("Enter the sudoku board line by line. Write empty fields as a \".\".")

var board: [Int] = []

for _ in 0..<9 {
	let line = readLine()!
	
	guard line.count == 9 else {
		print("Malformed Input - length: " + line)
		exit(1)
	}
	
	for char in line {
		if char == "." {
			board.append(0)
		} else {
			guard let value = Int(String(char)) else {
				print("Malformed Input - character: " + line)
				exit(1)
			}
			board.append(value)
		}
	}
	
}

let startBoard = SudokuBoard(values: board)

let solver = Solver(sudoku: startBoard)

let solvedBoard = solver.solve()

if solvedBoard.isDone() {
	print("Board completely solved!")
} else {
	print("I couldn't finish it... 😢\nThis is how far I got:")
}
print(solvedBoard)
