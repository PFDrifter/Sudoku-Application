//
//  StringUtils.swift
//  lab3
//
//  Created by Jennifer Terpstra on 2016-02-06.
//  Copyright © 2016 Jennifer Terpstra. All rights reserved.
//

import Foundation

extension String {
    
    // Returns true if the string contains only characters found in matchCharacters.
    func onlyAllowCharacters(matchCharacters: String) -> Bool {
        let characters = NSCharacterSet(charactersInString: matchCharacters).invertedSet
        return self.rangeOfCharacterFromSet(characters) == nil
    }
}

