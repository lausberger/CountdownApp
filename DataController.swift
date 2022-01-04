//
//  DataController.swift
//  Countdown
//
//  Created by Lucas Ausberger on 12/29/21.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Countdown")
    static let shared = DataController()
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    func getEventById(id: NSManagedObjectID) -> Event? {
        do {
            return try container.viewContext.existingObject(with: id) as? Event
        } catch  {
            print(error)
            return nil
        }
    }
    
    func deleteEvent(_ event: Event) {
            container.viewContext.delete(event)
        
            do {
                try container.viewContext.save()
            } catch {
                container.viewContext.rollback()
                print("Failed to delete event \(error)")
            }
        }
}
