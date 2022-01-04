//
//  ContentView.swift
//  Countdown
//
//  Created by Lucas Ausberger on 12/23/21.
//

import SwiftUI

struct EventToEdit {
    var get: Event?
}

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.colorScheme) var colorScheme
    @State var creatingEvent = false
    
    @State var editing = false
    @State var ETE: EventToEdit = EventToEdit()
    
    var body: some View {
        ZStack {
            NavigationView {
                EventListView(editing: $editing, eventHolder: $ETE)
                .listStyle(.plain)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            creatingEvent = true
                        }) {
                            Image(systemName: "plus")
                                .resizable()
                        }
                    }
                    /*
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                    */
                }
                .navigationTitle("Events")
            }
            if creatingEvent {
                Rectangle()
                    .foregroundColor(
                        colorScheme == .dark ?
                            Color.white.opacity(0.25) :
                            Color.black.opacity(0.5))
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    EventBuilder(active: $creatingEvent)
                }
            } else if editing {
                Rectangle()
                    .foregroundColor(
                        colorScheme == .dark ?
                            Color.white.opacity(0.25) :
                            Color.black.opacity(0.5))
                    .edgesIgnoringSafeArea(.all)
                if ETE.get != nil {
                    EventEditor(
                        event: ETE.get!,
                        newDate: ETE.get!.date!,
                        newTime: ETE.get!.date!.timeStamp()!,
                        newName: ETE.get!.name!,
                        newAllDay: ETE.get!.isAllDay,
                        editing: $editing)
                } else {
                    Text("Failed to edit event")
                        .background(Color.red)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
