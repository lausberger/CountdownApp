//
//  Event.swift
//  Countdown
//
//  Created by Lucas Ausberger on 12/23/21.
//
//  An extension of the entity class Event created within a .xcdatamodeld file
//
//  Attributes:
//  * date: Date
//  * name: String
//  * id: UUID
//  * isAllDay: Boolean
//  * recentlyEdited: Boolean

import Foundation

extension Event {

    private func getDate() -> Date { return self.date ?? Date.distantPast }
    
    public func getTime() -> Date? { return self.date?.timeStamp() ?? nil}

	public func viewDate() -> String {
		let fmtr = DateFormatter()
		fmtr.dateFormat = "EEEE, MMMM dd, yyyy"
		let date = self.getDate()
		let dateStr = fmtr.string(from: date)
        
		return dateStr
	}
    
    public func viewTime() -> String? {
        if (self.isAllDay) {
            return nil
        }
        let time = self.getTime()
        if time ==  nil {
            return nil
        }
        let fmtr = DateFormatter()
        fmtr.dateFormat = "h:mm a"
        let timeStr = fmtr.string(from: time!)
        
        return timeStr
    }

	public func timeUntil() -> TimeInterval {
		let curdate = Date()
		let eventdate = self.getDate()

		return eventdate - curdate 
	}
    
    private func intervalToArray() -> [Int] {
        let interval = self.timeUntil()
        if interval < 0 {
            return [0,0,0,0,0,0]
        }
        let scope = interval / (60*60*24*30.417*12)
        let years = floor(scope)
        let months = floor((scope - years) * 12)
        let days = floor((((scope - years) * 12) - months) * 30.417)
        let hours = floor((((((scope - years) * 12) - months) * 30.417) - days) * 24)
        let minutes = floor((((((((scope - years) * 12) - months) * 30.417) - days) * 24) - hours) * 60)
        let seconds = floor((((((((((scope - years) * 12) - months) * 30.417) - days) * 24) - hours) * 60) - minutes) * 60)
        let arr = [Int(years), Int(months), Int(days), Int(hours), Int(minutes), Int(seconds)]
        
        return arr
    }
    
    public func generateCountdownInfo() -> [(String, Int)] {
        let array = intervalToArray()
        let timeValueDict = TimeValueDict()
        var countdownArray: [(String, Int)] = []
        
        for i in 0..<array.count {
            var field: String = timeValueDict.tvd[i]!
            let value = array[i]
            
            if value > 0 {
                if value == 1 {
                    field.removeLast()
                }
                countdownArray.append((field, value))
            } else if i == 5 {
                countdownArray.append((field, value))
            }
        }
        
        return countdownArray
    }
    
    public func leadingInfo() -> [(String, Int)] {
        let cdi = generateCountdownInfo()
        let infoList: [(String, Int)] = cdi.count == 1 ? [cdi[0]] : [cdi[0], cdi[1]]
        
        return infoList
    }
}

struct TimeValueDict {
    public var tvd: [Int: String] = [0: "years", 1: "months", 2: "days", 3: "hours", 4: "minutes", 5: "seconds"]
}
