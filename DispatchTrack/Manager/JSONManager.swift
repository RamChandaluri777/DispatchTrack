//
//  JSONManager.swift
//  DispatchTrack
//
//  Created by mohan chandaluri on 29/02/24.
//

import Foundation

class ReadData: ObservableObject  {
    @Published var dispatches = [Dispatch]()
   
    
    var allOrders: [Dispatch] {
        return dispatches.filter { $0.statusCode == 0 }
    }
    var successfulOrders: [Dispatch] {
        return dispatches.filter { $0.statusCode == 1 }
    }
    
    var partialOrders: [Dispatch] {
        return dispatches.filter { $0.statusCode == 2 }
    }
    
    var failedOrders: [Dispatch] {
        return dispatches.filter { $0.statusCode == 3 }
    }
        
    init(){
        loadData()
    }
    
    func loadData()  {
        guard let url = Bundle.main.url(forResource: "UserData", withExtension: "json")
            else {
                print("Json file not found")
                return
            }
        
        guard let jsonData = try? Data(contentsOf: url) else {
            print("unable to load the data from JSON file")
            return
        }
        
        if let data = Dispatch.getDispatchData() , data.count > 0 {
            self.dispatches = data
        } else {
            do {
                let decoder = JSONDecoder()
                if let context = CodingUserInfoKey.context {
                    decoder.userInfo[context] = PersistenceController.shared.container.viewContext
                    let dispatches = try decoder.decode([Dispatch].self, from: jsonData)
                    Dispatch.insertDispatchData(dispatches)
                    self.dispatches = Dispatch.getDispatchData() ?? []
                    print(dispatches)
                } else {
                    fatalError("Failed to access context key")
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        
    }
     
}
