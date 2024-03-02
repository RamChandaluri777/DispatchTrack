//
//  Address+CoreDataProperties.swift
//  DispatchTrack
//
//  Created by mohan chandaluri on 3/1/24.
//
//

import Foundation
import CoreData


extension Address {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Address> {
        return NSFetchRequest<Address>(entityName: "Address")
    }
    
    static func saveContat(_ data: Address) {
        let managedObjectContext = PersistenceController.shared.container.viewContext
        let newItem = Address(context: managedObjectContext)
        newItem.id = data.id
        newItem.name = data.name
        newItem.latitude = data.latitude
        newItem.longitude = data.longitude
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving item: \(error)")
        }
    }

}

extension Address : Identifiable {

}
