//
//  EventEditor.swift
//  Countdown
//
//  Created by Lucas Ausberger on 12/31/21.
//

import SwiftUI

struct EventEditor: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.colorScheme) var colorScheme
    @State var event: Event
    @State var newDate: Date
    @State var newTime: Date
    @State var newName: String
    @State var newAllDay: Bool
    @Binding var editing: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .foregroundColor(
                    colorScheme == .dark ? Color.black : Color.white)
                .frame(width: 360, height: 600)
            VStack {
                ZStack {
                    Text("Edit Event")
                        .foregroundColor(Color.yellow)
                    HStack(spacing: 235) {
                        Button(action: {
                            editing = false
                        }) {
                            Text("Cancel")
                        }
                        Button(action: {
                            event.name = newName
                            if newAllDay {
                                event.date = newDate.changeTime(
                                    time: newDate.midnight)
                            } else {
                                event.date = newDate.changeTime(
                                    time: newTime)
                            }
                            event.isAllDay = newAllDay
                            do {
                                try moc.save()
                            } catch {
                                print("Error when saving to CoreData")
                            }
                            editing = false
                            event.recentlyEdited = true
                        }) {
                            Text("Save")
                        }
                    }
                }
                TextField("\(event.name!)", text: $newName)
                    .onReceive(newName.publisher.collect()) {
                        self.newName = String($0.prefix(200))
                    }
                    .padding(.vertical, 5)
                    .padding(.top)
                Divider()
                Toggle("All Day", isOn: $newAllDay)
                    .padding(.vertical, 5)
                ZStack {
                    let d =
                        DatePicker(
                            "Change time",
                            selection: $newTime,
                            displayedComponents: .hourAndMinute)
                        .padding(.vertical, 5)
                        .disabled(newAllDay == true)
                    d
                    if newAllDay {
                        d.colorInvert()
                    }
                }
                Divider()
                DatePicker(
                    "Change date",
                    selection: $newDate,
                    displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                Divider()
                Text("\(newDate.formattedString(time: newTime, b: newAllDay))")
                    .padding(.vertical, 5)
                    .font(.system(size: 15.5))
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .frame(width: 325)
            .background(colorScheme == .dark ? Color.black : Color.white)
            .padding()
        }
    }
}
