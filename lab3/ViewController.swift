//
//  ViewController.swift
//  lab3
//
//  Created by Jennifer Terpstra on 2016-01-25.
//  Copyright © 2016 Jennifer Terpstra. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var youWinLabel: UILabel!
    //resets the sudoku board
    @IBAction func reset(sender: UIButton) {
        for cell in (cells as NSArray as! [DataCell]) {
            if(cell.editable == true) {
                cell.answer.text = ""
                youWinLabel.hidden = true
                cell.backgroundColor = UIColor.whiteColor()
                cell.answer.backgroundColor = UIColor.whiteColor()
            }
        }
    }
    
    var len = 9
    var count = 0
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    var sudokuUtils: SudokuManager?
    
    var cells: NSMutableArray = []
    
    var gameBoard = [[DataCell]] (count: 9, repeatedValue: [DataCell](count: 9, repeatedValue: DataCell()))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        youWinLabel.hidden = true
        sudokuUtils = SudokuManager()
        gestureRecognizer()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // how many items you want to show in its grid
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 81
    }
    
    // create data
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DataCell", forIndexPath: indexPath) as! DataCell
        
        apperanceDataCell(cell, indexPath: indexPath)
        
        cell.xIndex = count / len
        cell.yIndex = count % len
        cell.answer.xIndex = cell.xIndex
        cell.answer.yIndex = cell.yIndex
        
        //randomize puzzel on program start up
        let sudoku: String = (sudokuUtils?.choosePuzzel())!
        //parse each letter from string
        let index = sudoku.startIndex.advancedBy(count)
        if(sudoku[index] != ".") {
            cell.answer.text =  String(sudoku[index])
            cell.answer.userInteractionEnabled = false
        }
        else{
            cell.answer.text =  ""
            cell.answer.delegate = self
            cell.answer.borderStyle = UITextBorderStyle.None
            cell.editable = true
            cell.answer.keyboardType = UIKeyboardType.NumberPad
        }
        
        if(cells.containsObject(cell) == false) {
            cells.addObject(cell)
        }
        //add cell to gameboard 2D array
        gameBoard[cell.xIndex][cell.yIndex] = cell
        
        cell.answer.addTarget(self, action: "validateCell:", forControlEvents: UIControlEvents.EditingChanged)
        count++
        return cell
    }
    
    // size for the cell
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return dataCellFrame(indexPath)
    }
    
    //Sets the datacell appearance features
    func apperanceDataCell(cell: DataCell, indexPath: NSIndexPath) {
        cell.layer.borderWidth = 1.5
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 3.5
        cell.layer.borderColor = UIColor.blackColor().CGColor
    }
    
    // selection behaviour
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    }
    
    func validateCell(textField: CoordinateTextField) {
        let cell = gameBoard[textField.xIndex][textField.yIndex]
        //if a cell was editable (not the default values) and was edited check for valid input
        if(cell.editable && cell.answer.text != ""){
            let valid = sudokuUtils!.checkValidSudoku(cell, gameBoard: gameBoard)
            //if invalid input, change user input to null and make background red
            if(!valid) {
                //check if there is no more valid input left
                if(sudokuUtils!.didLost(gameBoard)){
                    youWinLabel.text = "You Lost!"
                    youWinLabel.hidden = false
                }
                cell.answer.text = ""
                cell.backgroundColor = UIColor.redColor()
                cell.answer.backgroundColor = UIColor.redColor()
            }
            else{
                //check to see if the user has won
                if(sudokuUtils!.didWin(gameBoard)){
                    youWinLabel.text = "You Win!!"
                    youWinLabel.hidden = false
                }
                //check to see if any valid input is left
                else if(sudokuUtils!.didLost(gameBoard)){
                    youWinLabel.text = "You Lost!"
                    youWinLabel.hidden = false
                }
                //indicates valid cell
                cell.backgroundColor = UIColor.blueColor()
                cell.answer.backgroundColor = UIColor.blueColor()
            }
        }
        else{
            cell.backgroundColor = UIColor.whiteColor()
            cell.answer.backgroundColor = UIColor.whiteColor()
        }

    }
    
    func dataCellFrame(indexPath: NSIndexPath) -> CGSize {
        let screenSize = CollectionView.bounds
        let cellSize = screenSize.width / (CGFloat(10))
        return CGSize(width: cellSize, height: cellSize)
    }
    
    //Gives the textfield the allowed values on 1-9 with only 1 max value
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
      
        if string.characters.count == 0 {
            return true
        }
        
        let value = textField.text ?? ""
        let input = (value as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
    return(input.characters.count <= 1 && input.onlyAllowCharacters("123456789"))
    }
    
    //Dismisses the keyboard when the user clicks outside of the keyboard
    func gestureRecognizer() {
        let destoryKeyboard = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        destoryKeyboard.cancelsTouchesInView = false
        view.addGestureRecognizer(destoryKeyboard)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

}

