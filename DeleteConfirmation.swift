//
//  DeleteConfirmation.swift
//  Countdown
//
//  Created by Lucas Ausberger on 1/5/22.
//

import Foundation
import SwiftUI

struct DeleteConfirmation: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var deleting: Bool
    var event: Event
    
    func deleteEvent() {
        let delEvent = DataController.shared.getEventById(id: event.objectID)
        if let event = delEvent {
            DataController.shared.deleteEvent(event)
        }
    }
    
    var body: some View {
        ZStack {
                VStack {
                    Text("Delete this event?")
                        .font(.system(size: 20, weight: .bold))
                    Spacer()
                    Text("\(event.name ?? "")")
                    Spacer()
                    HStack(spacing: 50) {
                        Button(action: {
                            deleting = false
                        }, label: {
                            Text("Cancel")
                        })
                        Divider()
                            .frame(height: 30)
                        Button(action: {
                            let _ = NotificationHandler(event: event, remove: true)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                deleteEvent()
                            }
                            deleting = false
                        }, label: {
                            Text("Confirm")
                                .foregroundColor(Color.red)
                        })
                    }
                }.padding()
            }
            .frame(width: 300, height: 200)
            .background(colorScheme == .dark ? Color.black : Color.white)
            .cornerRadius(25)
    }
}
