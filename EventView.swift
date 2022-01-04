//
//  EventView.swift
//  Countdown
//
//  Created by Lucas Ausberger on 12/31/21.
//

//  Issues:
//
//  * EventEditor is not centered within screen due to offset caused by
//    navigation bar

import SwiftUI

struct EventView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var editing: Bool
    @State var e: Event
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    EventInfo(event: $e, name: $e.name, date: $e.date)
                    Spacer()
                    CountdownDisplay(event: e, arr: e.generateCountdownInfo())
                }
                .frame(
                    width: geometry.frame(in: .global).width,
                    height: geometry.frame(in: .global).height)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            editing = true
                        }) {
                            Image(systemName: "square.and.pencil")
                                .resizable()
                        }.disabled(editing)
                    }
                }
                if editing {
                    Rectangle()
                        .foregroundColor(
                            colorScheme == .dark ?
                                Color.white.opacity(0.25) :
                                Color.black.opacity(0.5))
                        .edgesIgnoringSafeArea(.all)
                    EventEditor(
                        event: e,
                        newDate: e.date!,
                        newTime: e.date!.timeStamp()!,
                        newName: e.name!,
                        newAllDay: e.isAllDay,
                        editing: $editing)
                        .frame(
                            width: geometry.frame(in: .global).width,
                            height: geometry.frame(in: .global).height)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct EventInfo: View {
    @Binding var event: Event
    @Binding var name: String?
    @Binding var date: Date?
    
    var body: some View {
        VStack {
            Text("\(name!)")
                .font(
                    .system(
                        size: 30,
                        weight: .bold,
                        design: .default))
                .padding(.horizontal, 15)
                .padding(.top, 10)
                .multilineTextAlignment(.center)
            Text("\(date!.dateOnly())")
                .font(.system(size: 22, design: .default))
                .padding(.vertical, 10)
            if !event.isAllDay {
                Text("\(date!.timeOnly())")
                    .font(.system(size: 22, design: .default))
            }
        }
    }
}

struct CountdownDisplay: View {
    @State var event: Event
    @State var arr: [(String, Int)]
    @State private var timer: Timer?
    
    var body: some View {
        HStack {
            ForEach(arr, id: \.self.0) { field, value in
                VStack {
                    Text("\(value.shortenIfNecessary())")
                        .font(.system(size: 24, weight: .bold))
                    Text("\(field)")
                        .font(.system(size: 16))
                }
            }
        }
        .onChange(of: event.recentlyEdited) { _ in
            if event.recentlyEdited == true { // can onChange be recursive?
                arr = event.generateCountdownInfo()
                event.recentlyEdited = false
                if event.timeUntil() > 0 {
                    timer =
                        Timer.scheduledTimer(
                            withTimeInterval: 1,
                            repeats: true) { _ in
                        arr = event.generateCountdownInfo()
                        if event.timeUntil() < 0 {
                            timer?.invalidate()
                        }
                    }
                }
            }
        }
        .onAppear {
            if event.timeUntil() > 0 {
                timer =
                    Timer.scheduledTimer(
                        withTimeInterval: 1,
                        repeats: true) { _ in
                    arr = event.generateCountdownInfo()
                    if event.timeUntil() < 0 {
                        timer?.invalidate()
                    }
                }
            }
        }
        .onDisappear {
            if timer != nil {
                timer!.invalidate()
            }
        }
        .frame(height: 100)
        .padding(.horizontal, 5.0)
    }
}
