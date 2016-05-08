//
//  SudokuManager.swift
//  lab3
//
//  Created by Jennifer Terpstra on 2016-02-02.
//  Copyright © 2016 Jennifer Terpstra. All rights reserved.
//

import Foundation
import UIKit

public class SudokuManager {
    
    var fileName = "sudoku.db"
    var choosePuzzelNum = 0
    var puzzelCount: UInt32 = 0
    
    //array to store available sudoku puzzels
    var sudokuStringArray: [String] = []

    
    init () {
        sudokuStringArray = readFile()
        puzzelCount = UInt32(sudokuStringArray.count)
        choosePuzzelNum = Int(arc4random_uniform(puzzelCount))
        
        
    }
    
    //Reads in sudoku database file
    func readFile() ->[String] {
        guard let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "txt") else {
            return []
        }
        var sudokuStringArray: [String] = []
        
        do {
            //reads file into string
            let content = try String(contentsOfFile:path, encoding: NSUTF8StringEncoding)
            //parses string by new file
            sudokuStringArray = content.componentsSeparatedByString("\n")
        }
        catch _ as NSError {
            print("An error has occured when reading the file")
        }
        return sudokuStringArray
    }
    
    //Checks to see if inputted value is a valid answer for the cell
    func checkValidSudoku(cell: DataCell, gameBoard: [[DataCell]]) -> Bool {
        let value = Int(cell.answer.text!)
        let x = cell.xIndex
        let y = cell.yIndex
        //check row and columsn for valid values
        for var i = 0; i <= 8; i++ {
            if(gameBoard[i][y].answer.text != "") {
                if(Int(gameBoard[i][y].answer.text!) == value && i != x) {
                    return false
                }
            }
            if(gameBoard[x][i].answer.text != "") {
                if(Int(gameBoard[x][i].answer.text!) == value && i != y) {
                    return false
                }
            }
            
        }
        //check the 3x3 cube for valid values
        let cubeX = (x / 3) * 3
        let cubeY = (y / 3) * 3
        
        for(var r = 0; r < 3; r++) {
            for(var c = 0; c < 3; c++) {
            if(gameBoard[cubeX+c][cubeY+r].answer.text != ""){
                if(Int(gameBoard[cubeX+c][cubeY+r].answer.text!)! == value && (cubeX+c != x) && (cubeY+r != y)) {
                    return false ;
                }
            }
            }
        }
        return true
    }
    //chooses random puzzel from the sudoku.db.txt
    func choosePuzzel() -> String {
        if(sudokuStringArray.count > 0){
            let sudoku: String = sudokuStringArray[choosePuzzelNum]
            return sudoku
        }
        return ""
    }
    
    
    //checks to see if the user has won, if there are no "" (starting init values) left on the board
    func didWin(gameBoard: [[DataCell]]) -> Bool {
        for(var r = 0; r <= 8; r++) {
            for(var c = 0; c <= 8; c++) {
                if(gameBoard[r][c].answer.text == ""){
                    return false
                }
            }
        }
        return true
    }
    
    //checks to see if any valid inputs are left in the empty
    func didLost(gameBoard: [[DataCell]]) -> Bool {
        
        var cell: DataCell
        var isValid: Bool
        let temp: String = ""
        
        for(var r = 0; r <= 8; r++) {
            for(var c = 0; c <= 8; c++) {
                if(gameBoard[r][c].answer.text == ""){
                    cell = gameBoard[r][c]
                    //checks for all numbesr between 1 to 9 to see if valid input exists
                    for(var num = 1; num <= 9; num++) {
                        cell.answer.text = String(num)
                        isValid = self.checkValidSudoku(cell, gameBoard: gameBoard)
                        cell.answer.text = temp
                        
                        //if at least one valid input exists than they havn't lost yet
                        if(isValid){
                            return false
                        }
                    }
                    
                }
            }
        }
        return true
    }
    
}
