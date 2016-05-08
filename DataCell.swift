//
//  DataCell.swift
//  lab3
//
//  Created by Jennifer Terpstra on 2016-01-25.
//  Copyright © 2016 Jennifer Terpstra. All rights reserved.
//

import UIKit

class DataCell: UICollectionViewCell {
    //@IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var answer: CoordinateTextField!
    var editable = false
    var xIndex = 0
    var yIndex = 0
    
}
