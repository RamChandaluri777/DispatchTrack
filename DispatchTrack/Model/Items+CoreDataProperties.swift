//
//  Items+CoreDataProperties.swift
//  DispatchTrack
//
//  Created by mohan chandaluri on 3/1/24.
//
//

import Foundation
import CoreData


extension Items {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Items> {
        return NSFetchRequest<Items>(entityName: "Items")
    }
    
    static func saveItem(_ data: Items) {
        let managedObjectContext = PersistenceController.shared.container.viewContext
        let newItem = Items(context: managedObjectContext)
        newItem.id = data.id
        newItem.name = data.name
        newItem.quantity = data.quantity
        newItem.unitPrice = data.unitPrice
        newItem.code = data.code
        newItem.quantityRef = data.quantityRef
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving item: \(error)")
        }
    }
}

