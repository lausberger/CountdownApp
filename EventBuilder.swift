//
//  EventBuilder.swift
//  Countdown
//
//  Created by Lucas Ausberger on 12/31/21.
//

import SwiftUI

struct EventBuilder: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.colorScheme) var colorScheme
    @State private var date = Date()
    @State private var time = Date()
    @State private var name = ""
    @State private var allDay = true
    var color: Color = Color.white

    @Binding var active: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .foregroundColor(
                    colorScheme == .dark ? Color.black : Color.white)
                .frame(width: 360, height: 600)
            VStack {
                ZStack {
                    Text("New Event")
                        .foregroundColor(Color.green)
                    HStack(spacing: 235) {
                        Button(action: {
                            active = false
                        }) {
                            Text("Cancel")
                        }
                        Button(action: {
                            let event = Event(context: moc)
                            if name == "" {
                                name = "Event"
                            }
                            event.id = UUID()
                            event.name = name
                            if allDay {
                                event.date = date.midnight
                            } else {
                                event.date = date.changeTime(time: time)
                            }
                            event.isAllDay = allDay
                            event.recentlyEdited = false
                            do {
                                try moc.save()
                            } catch {
                                print("Error when saving to CoreData")
                            }
                            
                            let _ = NotificationHandler(
                                event: event, remove: false)
                            
                            active = false
                        }) {
                            Text("Save")
                        }
                    }
                }
                TextField("Enter event name", text: $name)
                    .onReceive(name.publisher.collect()) {
                            self.name = String($0.prefix(200))
                    }
                    .padding(.vertical, 5)
                    .padding(.top)
                Divider()
                Toggle("All Day", isOn: $allDay)
                    .padding(.vertical, 5)
                ZStack {
                    let d =
                        DatePicker(
                            "Select a time",
                            selection: $time,
                            displayedComponents: .hourAndMinute)
                        .padding(.vertical, 5)
                        .disabled(allDay == true)
                    d
                    if allDay {
                        d.colorInvert()
                    }
                }
                Divider()
                DatePicker(
                    "Select a date",
                    selection: $date,
                    displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                Divider()
                Text("\(date.formattedString(time: time, b: allDay))")
                    .padding(.vertical, 5)
                    .font(.system(size: 15.5))
            }
            .frame(width: 325)
            .background(colorScheme == .dark ? Color.black : Color.white)
            .padding()
        }
    }
}
