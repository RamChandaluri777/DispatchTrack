//
//  DispatchItem+CoreDataClass.swift
//  DispatchTrack
//
//  Created by mohan chandaluri on 3/1/24.
//
//

import Foundation
import CoreData

@objc(Dispatch)
public class Dispatch: NSManagedObject, Codable {
    @NSManaged public var id: Int64
    @NSManaged public var statusCode: Int64
    @NSManaged public var dispatchSubStatusId: Int64
    @NSManaged public var estimatedAt: String?
    @NSManaged public var slot: Int64
    @NSManaged public var isTrunk: Bool
    @NSManaged public var isPickup: Bool
    @NSManaged public var canManageDispatch: Bool
    @NSManaged public var dispatchGuide: DispatchGuide?
    
    enum CodingKeys: String, CodingKey {
        case id
        case statusCode = "status_code"
        case dispatchSubStatusId = "dispatch_sub_status_id"
        case estimatedAt = "estimated_at"
        case slot
        case isTrunk = "is_trunk"
        case isPickup = "is_pickup"
        case destinationId = "destination_id"
        case canManageDispatch = "can_manage_dispatch"
        case dispatchGuide = "dispatch_guide"
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
              let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext else {
            fatalError("Failed to decode Dispatch: missing managedObjectContext in userInfo")
        }
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Dispatch", in: managedObjectContext) else {
            fatalError("Failed to decode Dispatch: missing entity configuration")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int64.self, forKey: .id)
        statusCode = try container.decode(Int64.self, forKey: .statusCode)
        
        estimatedAt = try container.decode(String.self, forKey: .estimatedAt)
        slot = try container.decode(Int64.self, forKey: .slot)
        isTrunk = try container.decode(Bool.self, forKey: .isTrunk)
        isPickup = try container.decode(Bool.self, forKey: .isPickup)
        canManageDispatch = try container.decode(Bool.self, forKey: .canManageDispatch)
        dispatchGuide = try container.decode(DispatchGuide.self, forKey: .dispatchGuide)
        if let dispatchSubStatusIdInt64 = try container.decodeIfPresent(Int64.self, forKey: .dispatchSubStatusId) {
            self.dispatchSubStatusId = dispatchSubStatusIdInt64
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(statusCode, forKey: .statusCode)
        try container.encode(dispatchSubStatusId, forKey: .dispatchSubStatusId)
        try container.encode(estimatedAt, forKey: .estimatedAt)
        try container.encode(slot, forKey: .slot)
        try container.encode(isTrunk, forKey: .isTrunk)
        try container.encode(isPickup, forKey: .isPickup)
        try container.encode(canManageDispatch, forKey: .canManageDispatch)
        try container.encode(dispatchGuide, forKey: .dispatchGuide)
    }
}


extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}
