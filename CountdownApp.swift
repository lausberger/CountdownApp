//
//  CountdownApp.swift
//  Countdown
//
//  Created by Lucas Ausberger on 12/23/21.
//

//  Issues:
//
//  * Receiving significant UIViewAlertForUnsatisfiableConstraints printouts
//    in console at the start of runtime. It is likely that these are caused by
//    inconsistencies in the values given to objects within the navigation bar.
//    - Not known to affect functionality at this time
//
//  * Receiving CFRunLoopError_RunCalledWithInvalidMode printout whenever
//    the "All Day" toggle is switched within EventBuilder or EventEditor. This
//    may be caused by interactions between timer objects and AllDay booleans.
//    It is also possible that use of DispatchQueue could alleviate this issue.
//    - Not known to affect functionality at this time

import SwiftUI

@main
struct CountdownApp: App {
    
    var body: some Scene {
        WindowGroup {
            GeometryReader { geometry in
                ContentView()
                    .environment(
                        \.managedObjectContext,
                        DataController.shared.container.viewContext)
            }.ignoresSafeArea(.keyboard)
            
        }
    }
}
