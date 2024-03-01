//
//  OrdersModel.swift
//  DispatchTrack
//
//  Created by mohan chandaluri on 29/02/24.
//

import Foundation

struct Dispatch: Decodable, Identifiable {
    let id: Int
    let statusCode: Int
    let dispatchSubStatusId: Int?
    let estimatedAt: String
    let slot: Int
    let isTrunk: Bool
    let isPickup: Bool
    let destinationId: Int?
    let canManageDispatch: Bool
    let dispatchGuide: DispatchGuide
    
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
}

struct DispatchGuide: Decodable {
    let code: String
    let mode: Int
    let minDeliveryTime: String
    let maxDeliveryTime: String
    let locked: Bool
    let pincodeEnabled: Bool
    let address: Address
    let pickupAddress: String? 
    let contact: Contact
    let customFields: [CustomField]
    let items: [Item]
    
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
    
    struct Address: Decodable {
        let id: Int
        let name: String
        let latitude: String
        let longitude: String
    }
    
    struct Contact: Decodable {
        let id: Int
        let email: String
        let phone: String
        let identifier: String
        let name: String
    }
    
    struct CustomField: Decodable {
        let id: Int
        let value: String
        let name: String
        let color: String?
    }
    
    struct Item: Decodable {
        let id: Int
        let name: String
        let quantity: Int
        let unitPrice: String
        let code: String
        let quantityRef: String?
        let customFields: [CustomField]
        
        enum CodingKeys: String, CodingKey {
                    case id
                    case name
                    case quantity
                    case unitPrice = "unit_price"
                    case code
                    case quantityRef = "quantity_ref"
                    case customFields = "custom_fields"
                }
    }
}
