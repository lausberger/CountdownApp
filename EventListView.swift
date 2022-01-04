//
//  EventListView.swift
//  Countdown
//
//  Created by Lucas Ausberger on 12/31/21.
//
//  Bugs:
//  * Unable to implement an EditButton() due to the lack of a compatible
//    method for deleting events from FetchedReults<Event> object

import SwiftUI

struct EventListView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(
        entity: Event.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Event.date, ascending: true)]
        ) var events: FetchedResults<Event>
    
    @Binding var editing: Bool
    @Binding var eventHolder: EventToEdit
    
    func deleteEvent(event: Event) {
        let event = DataController.shared.getEventById(id: event.objectID)
        if let event = event {
            DataController.shared.deleteEvent(event)
        }
    }
    
    var body: some View {
        List {
            ForEach(events) { event in
                NavigationLink(destination:
                    EventView(editing: false, e: event)
                        .ignoresSafeArea(.keyboard)) {
                    EventRow(e: event, preview: event.leadingInfo())
                }.swipeActions(edge: .leading, allowsFullSwipe: false) {
                    Button(role: .destructive, action: {
                        deleteEvent(event: event)
                    }) {
                        Label("Delete", systemImage: "trash")
                    }
                }.swipeActions(edge: .leading, allowsFullSwipe: false) {
                    Button(action: {
                        editing = true
                        eventHolder.get = event
                    }) {
                        Label("Edit", systemImage: "pencil")
                    }
                }
            }
            //.onDelete(perform: deleteEvent(event: ))
            // onDelete uses indices for deletion, not event objects!
        }
        .listStyle(.plain)
    }
}

struct EventRow: View {
    @State var e: Event
    @State var preview: [(String, Int)]
    @State private var timer: Timer?
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .center) {
                Text("\(preview[0].1.shortenIfNecessary())") // value
                    .font(.system(size: 20, weight: .bold))
                Text("\(preview[0].0)") // field
                    .font(.system(size: 16))
            }
            .frame(width: 65)
            .padding(.trailing, 5)
            VStack(alignment: .leading) {
                Text(e.name ?? "ERROR: Failed to load name")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.bottom, 1)
                if (e.viewTime() != nil) {
                    Text("\(e.viewDate()) at \(e.viewTime()!)")
                        .font(.system(size: 14))
                } else {
                    Text(e.viewDate())
                        .font(.system(size: 14))
                }
            }
            .padding(.leading, 5)
            .frame(height: 90)
        }
        .onAppear {
            preview = e.leadingInfo()
            if e.timeUntil() > 0 {
                if preview.count > 1 {
                    timer =
                        Timer.scheduledTimer(
                            withTimeInterval:
                                Double(Date.convertInfoToSeconds(
                                    info: preview.last!)),
                            repeats: true) { _ in
                        preview = e.leadingInfo()
                        if e.timeUntil() <= 0 {
                            timer?.invalidate()
                        }
                    }
                } else { // when only seconds remain in countdown
                    timer =
                        Timer.scheduledTimer(
                            withTimeInterval: 1,
                            repeats: true) { _ in
                        preview = e.leadingInfo()
                        if e.timeUntil() <= 0 {
                            timer?.invalidate()
                        }
                    }
                }
            }
        }
        .onDisappear {
            if timer != nil {
                timer!.invalidate()
            }
        }
    }
}
