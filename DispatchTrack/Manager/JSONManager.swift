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
        
        do {
            let decoder = JSONDecoder()
            let dispatches = try decoder.decode([Dispatch].self, from: jsonData)
            self.dispatches = dispatches
            print(dispatches)
        } catch {
            print("Error decoding JSON: \(error)")
        }
       
        
    }
     
}
