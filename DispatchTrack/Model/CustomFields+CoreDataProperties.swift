//
//  CustomFields+CoreDataProperties.swift
//  DispatchTrack
//
// Created by mohan chandaluri on 3/1/24.
//
//

import Foundation
import CoreData


extension CustomFields {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CustomFields> {
        return NSFetchRequest<CustomFields>(entityName: "CustomFields")
    }
    
    static func saveCustomField(_ data: CustomFields) {
        let managedObjectContext = PersistenceController.shared.container.viewContext
        let newItem = CustomFields(context: managedObjectContext)
        newItem.id = data.id
        newItem.name = data.name
        newItem.value = data.value
        newItem.color = data.color
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving item: \(error)")
        }
    }

}

extension CustomFields : Identifiable {

}
