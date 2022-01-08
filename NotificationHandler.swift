//
//  NotificationHandler.swift
//  Countdown
//
//  Created by Lucas Ausberger on 1/5/22.
//

import Foundation
import UserNotifications

class NotificationHandler {
    
    init(event: Event, remove: Bool) {
        if remove {
            UNUserNotificationCenter.current()
                .removePendingNotificationRequests(
                    withIdentifiers: [event.id!.uuidString])
        } else if event.timeUntil() > 0 {
            let content = UNMutableNotificationContent()
            content.title = event.name!
            //content.subtitle = event.date!.formattedString(
            //    time: event.getTime()!,
            //    b: event.isAllDay)
            content.sound = UNNotificationSound.default
            
            var trigger: UNTimeIntervalNotificationTrigger
            if event.isAllDay {
                let allDayNotificationTime =
                    event.date!.midnight + (60 * 60 * 8) - Date()
                trigger = UNTimeIntervalNotificationTrigger(
                    timeInterval: allDayNotificationTime,
                    repeats: false)
            } else {
                let notificationTime = event.date! - Date()
                trigger = UNTimeIntervalNotificationTrigger(
                    timeInterval: notificationTime,
                    repeats: false)
            }
            
            let request = UNNotificationRequest(
                identifier: event.id!.uuidString,
                content: content,
                trigger: trigger)
            
            UNUserNotificationCenter.current().add(
                request, withCompletionHandler: { error in
                    if let error = error {
                        print(error)
                    }
            })
        }
    }
}
