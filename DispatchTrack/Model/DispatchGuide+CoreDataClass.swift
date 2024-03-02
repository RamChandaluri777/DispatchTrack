//
//  DispatchGuide+CoreDataClass.swift
//  DispatchTrack
//
//  Created by mohan chandaluri on 3/1/24.
//
//

import Foundation
import CoreData

@objc(DispatchGuide)
public class DispatchGuide: NSManagedObject, Codable {
    
    @NSManaged public var code: String?
    @NSManaged public var mode: Int64
    @NSManaged public var minDeliveryTime: String?
    @NSManaged public var maxDeliveryTime: String?
    @NSManaged public var locked: Bool
    @NSManaged public var pincodeEnabled: Bool
    @NSManaged public var pickupAddress: String?
    @NSManaged public var address: Address?
    @NSManaged public var contact: Contact?
    @NSManaged public var customFields: NSSet?
    @NSManaged public var items: NSSet?
    
    
    enum CodingKeys: String, CodingKey {
        case code
        case mode
        case minDeliveryTime = "min_delivery_time"
        case maxDeliveryTime = "max_delivery_time"
        case locked
        case pincodeEnabled = "pincode_enabled"
        case address
        case pickupAddress = "pickup_address"
        case contact
        case customFields = "custom_fields"
        case items
    }
    
    // Implementing the init(from:) initializer
    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
              let context = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext else {
            fatalError("Failed to decode Address: missing managedObjectContext in userInfo")
        }
        
        guard let entity = NSEntityDescription.entity(forEntityName: "DispatchGuide", in: context) else {
            fatalError("Failed to decode DispatchGuide: missing entity configuration")
        }
        
        self.init(entity: entity, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(String.self, forKey: .code)
        mode = try container.decode(Int64.self, forKey: .mode)
        minDeliveryTime = try container.decode(String.self, forKey: .minDeliveryTime)
        maxDeliveryTime = try container.decode(String.self, forKey: .maxDeliveryTime)
        locked = try container.decode(Bool.self, forKey: .locked)
        pincodeEnabled = try container.decode(Bool.self, forKey: .pincodeEnabled)
        address = try container.decode(Address.self, forKey: .address)
        contact = try container.decode(Contact.self, forKey: .contact)
    }
    
    // Implementing the encode(to:) method
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(mode, forKey: .mode)
        try container.encode(minDeliveryTime, forKey: .minDeliveryTime)
        try container.encode(maxDeliveryTime, forKey: .maxDeliveryTime)
        try container.encode(locked, forKey: .locked)
        try container.encode(pincodeEnabled, forKey: .pincodeEnabled)
        try container.encode(address, forKey: .address)
        try container.encode(contact, forKey: .contact)
    }
}
