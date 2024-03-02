//
//  DispatchGuide+CoreDataProperties.swift
//  DispatchTrack
//
//  Created by mohan chandaluri on 3/1/24.
//
//

import Foundation
import CoreData


extension DispatchGuide {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DispatchGuide> {
        return NSFetchRequest<DispatchGuide>(entityName: "DispatchGuide")
    }
    
    static func saveContat(_ data: DispatchGuide) {
        let managedObjectContext = PersistenceController.shared.container.viewContext
        let newItem = DispatchGuide(context: managedObjectContext)
        newItem.code = data.code
        newItem.mode = data.mode
        newItem.minDeliveryTime = data.minDeliveryTime
        newItem.maxDeliveryTime = data.maxDeliveryTime
        newItem.locked = data.locked
        newItem.pincodeEnabled = data.pincodeEnabled
        newItem.pickupAddress = data.pickupAddress
        newItem.address = data.address
        newItem.contact = data.contact
        newItem.customFields = data.customFields
        newItem.items = data.items
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving item: \(error)")
        }
    }
}

// MARK: Generated accessors for customFields
extension DispatchGuide {

    @objc(addCustomFieldsObject:)
    @NSManaged public func addToCustomFields(_ value: CustomFields)

    @objc(removeCustomFieldsObject:)
    @NSManaged public func removeFromCustomFields(_ value: CustomFields)

    @objc(addCustomFields:)
    @NSManaged public func addToCustomFields(_ values: NSSet)

    @objc(removeCustomFields:)
    @NSManaged public func removeFromCustomFields(_ values: NSSet)

}

// MARK: Generated accessors for items
extension DispatchGuide {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: Items)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: Items)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension DispatchGuide : Identifiable {

}
