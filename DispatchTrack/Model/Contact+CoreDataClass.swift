//
//  Contact+CoreDataClass.swift
//  DispatchTrack
//
//  Created by mohan chandaluri on 3/1/24.
//
//

import Foundation
import CoreData

@objc(Contact)
public class Contact: NSManagedObject, Codable {
    
    @NSManaged public var id: Int64
    @NSManaged public var email: String?
    @NSManaged public var phone: String?
    @NSManaged public var identifier: String?
    @NSManaged public var name: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case phone
        case identifier
        case name
    }
    
    // Implementing the init(from:) initializer
    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
              let context = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext else {
            fatalError("Failed to decode Address: missing managedObjectContext in userInfo")
        }
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Contact", in: context) else {
            fatalError("Failed to decode Address: missing entity configuration")
        }
        
        self.init(entity: entity, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int64.self, forKey: .id)
        email = try container.decode(String.self, forKey: .email)
        phone = try container.decode(String.self, forKey: .phone)
        identifier = try container.decode(String.self, forKey: .identifier)
        name = try container.decode(String.self, forKey: .name)
    }
    
    // Implementing the encode(to:) method
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(phone, forKey: .phone)
        try container.encode(identifier, forKey: .identifier)
    }
}
