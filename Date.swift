//
//  Date.swift
//  Countdown
//
//  Created by Lucas Ausberger on 1/3/22.
//

import Foundation

extension Date {

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    public func timeStamp() -> Date? {
        guard let time =
            Calendar.current.date(
                from: Calendar.current.dateComponents([.hour, .minute], from: self))
        else {
            return nil
        }
        return time
    }
    
    // b represents whether a date is an "all day" date or not
    public func formattedString(time: Date, b: Bool) -> String {
        let fmtr = DateFormatter()
        fmtr.dateStyle = .full
        var temp = self
        if !b {
            fmtr.timeStyle = .short
            temp = self.changeTime(time: time)
        }
        let formattedString = fmtr.string(from: temp)
        
        return formattedString
    }
    
    public func dateOnly() -> String {
        let fmtr = DateFormatter()
        fmtr.dateStyle = .full
        fmtr.timeStyle = .none
        
        return fmtr.string(from: self)
    }
    
    public func timeOnly() -> String {
        let fmtr = DateFormatter()
        fmtr.dateStyle = .none
        fmtr.timeStyle = .short
        
        return fmtr.string(from: self)
    }
    
    public func changeTime(time: Date) -> Date {
        let calendar = Calendar.current
        let dateComponents =
            calendar.dateComponents([.year, .month, .day], from: self)
        let timeComponents =
            calendar.dateComponents([.hour, .minute], from: time)
        var merged = DateComponents()
        merged.year = dateComponents.year
        merged.month = dateComponents.month
        merged.day = dateComponents.day
        merged.hour = timeComponents.hour
        merged.minute = timeComponents.minute
        
        return calendar.date(from: merged)!
    }
    
    static func convertInfoToSeconds(info: (String, Int)) -> Int {
        var secInt: Int = info.1
        let field: String = String(info.0.prefix(3))
        // if value already in seconds, do nothing
        if field == "min" { // minutes
            secInt = secInt * 60
        } else if field == "hou" { // hours
            secInt = secInt * 60 * 60
        } else if field == "day" { // days
            secInt = secInt * 60 * 60 * 24
        } else if field == "mon" { // months
            secInt = secInt * 60 * 60 * 24 * 30
        } else if field == "yea" {
            print("Date.convertInfoToSeconds given year value")
            return -1
        }
        
        return secInt
    }
    
    var midnight: Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: self)
    }
}
