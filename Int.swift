//
//  Int.swift
//  Countdown
//
//  Created by Lucas Ausberger on 1/3/22.
//

import Foundation

extension Int {
    
    func shortenIfNecessary() -> String {
        var shortenedStr: String = String(self)
        
        if self >= 1000 {
            let tempInt = self / 100
            let tempStr = String(tempInt)
            let tempArr = Array(tempStr)
            let firstDigit: Character = tempArr[0]
            let secondDigit: Character = tempArr[1]
            if tempArr == ["1", "0"] {
                shortenedStr = "1K"
            } else {
                shortenedStr = "\(firstDigit).\(secondDigit)K"
            }
        }
        
        return shortenedStr
    }
}
