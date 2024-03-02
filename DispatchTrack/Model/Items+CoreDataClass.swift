//
//  Items+CoreDataClass.swift
//  DispatchTrack
//
//  Created by mohan chandaluri on 3/1/24.
//
//

import Foundation
import CoreData

@objc(Item)
public class Items: NSManagedObject, Codable {
    
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var quantity: Int64
    @NSManaged public var unitPrice: Float
    @NSManaged public var code: String?
    @NSManaged public var quantityRef: String?
    @NSManaged public var customFields: NSSet?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case quantity
        case quantityRef = "quantity_ref"
        case unitPrice = "unit_price"
        case code
        case customFields = "custom_fields"
    }
    
    // Implementing the init(from:) initializer
    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
              let context = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext else {
            fatalError("Failed to decode Address: missing managedObjectContext in userInfo")
        }
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Items", in: context) else {
            fatalError("Failed to decode Address: missing entity configuration")
        }
        
        self.init(entity: entity, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int64.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        quantity = try container.decode(Int64.self, forKey: .quantity)
        unitPrice = try container.decode(Float.self, forKey: .unitPrice)
        code = try container.decode(String.self, forKey: .code)
        quantityRef = try container.decode(String.self, forKey: .quantityRef)
    }
    
    // Implementing the encode(to:) method
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(unitPrice, forKey: .unitPrice)
        try container.encode(code, forKey: .code)
        try container.encode(quantityRef, forKey: .quantityRef)
    }
}
