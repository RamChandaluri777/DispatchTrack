//
//  Contact+CoreDataProperties.swift
//  DispatchTrack
//
//  Created by mohan chandaluri on 3/1/24.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }
    
    static func saveContat(_ data: Contact) {
        let managedObjectContext = PersistenceController.shared.container.viewContext
        let newItem = Contact(context: managedObjectContext)
        newItem.id = data.id
        newItem.name = data.name
        newItem.email = data.email
        newItem.phone = data.phone
        newItem.identifier = data.identifier
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving item: \(error)")
        }
    }

}

extension Contact : Identifiable {

}
