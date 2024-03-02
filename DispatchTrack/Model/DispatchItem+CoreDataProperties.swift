//
//  DispatchItem+CoreDataProperties.swift
//  DispatchTrack
//
// Created by mohan chandaluri on 3/1/24.
//
//

import Foundation
import CoreData


extension Dispatch {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dispatch> {
        return NSFetchRequest<Dispatch>(entityName: "Dispatch")
    }
    
    static func insertDispatchData(_ dataArray: [Dispatch]) {
        // Assuming you have a managed object context
        let managedObjectContext = PersistenceController.shared.container.viewContext

        for data in dataArray {
            // Create a new Dispatch object
            let newDispatch = Dispatch(context: managedObjectContext)
            
            // Set properties
            newDispatch.id = data.id
            newDispatch.statusCode = data.statusCode
            newDispatch.dispatchSubStatusId = data.dispatchSubStatusId
            newDispatch.estimatedAt = data.estimatedAt
            newDispatch.slot = data.slot
            newDispatch.isTrunk = data.isTrunk
            newDispatch.isPickup = data.isPickup
            newDispatch.canManageDispatch = data.canManageDispatch
            newDispatch.dispatchGuide = data.dispatchGuide
            
            // Save the managed object context
            do {
                try managedObjectContext.save()
                print("Data saved successfully")
            } catch {
                print("Failed to save data: \(error)")
            }
        }
    }
    
    static func getDispatchData() -> [Dispatch]? {
        // Assuming you have a managed object context
        let managedObjectContext = PersistenceController.shared.container.viewContext

        // Create a fetch request for the Dispatch entity
        let fetchRequest: NSFetchRequest<Dispatch> = Dispatch.fetchRequest()

        do {
            // Execute the fetch request
            let dispatches = try managedObjectContext.fetch(fetchRequest)
            return dispatches
        } catch {
            print("Failed to fetch data: \(error)")
        }
        return nil
    }
}

extension Dispatch : Identifiable {

}
