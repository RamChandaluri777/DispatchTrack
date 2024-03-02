//
//  CustomFields+CoreDataClass.swift
//  DispatchTrack
//
// Created by mohan chandaluri on 3/1/24.
//
//

import Foundation
import CoreData

@objc(CustomField)
public class CustomFields: NSManagedObject, Codable {
    
    @NSManaged public var id: Int64
    @NSManaged public var value: String?
    @NSManaged public var name: String?
    @NSManaged public var color: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case value
        case name
        case color
    }
    
    // Implementing the init(from:) initializer
    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
              let context = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext else {
            fatalError("Failed to decode Address: missing managedObjectContext in userInfo")
        }
        
        guard let entity = NSEntityDescription.entity(forEntityName: "CustomFields", in: context) else {
            fatalError("Failed to decode Address: missing entity configuration")
        }
        
        self.init(entity: entity, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int64.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        value = try container.decode(String.self, forKey: .value)
        color = try container.decode(String.self, forKey: .color)
    }
    
    // Implementing the encode(to:) method
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(value, forKey: .value)
        try container.encode(color, forKey: .color)
    }
    
}
