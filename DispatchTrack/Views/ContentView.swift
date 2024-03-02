//
//  ContentView.swift
//  DispatchTrack
//
//  Created by mohan chandaluri on 29/02/24.
//

import SwiftUI
import CoreData
import MapKit

enum OrderStatus: Int, CaseIterable {
    
    case successful = 1
    case partial = 2
    case failed =  3
    
    var color: Color {
        switch self {
        case .successful:
            return .green
        case .partial:
            return .yellow
        case .failed:
            return .red
        }
    }
    
    var titles: String {
        switch self {
        case .successful:
            return "Successful Orders"
        case .partial:
            return "Partial Orders"
        case .failed:
            return "Failed Orders"
        }
    }
}

struct Location: Identifiable {
    let id :Int
    var name: String
    var coordinate: CLLocationCoordinate2D
}

struct ContentView: View {
    @ObservedObject var orderData = ReadData()
    @Environment(\.managedObjectContext) private var viewContext
    @State private var locations: [Location] = []
    @State private var tappedCoordinate: CLLocationCoordinate2D?
    @State private var tappedLocation: Dispatch?
    
    var items: FetchedResults<Items>?
    @State private var selectedIndex = 0
    @State private var selectedFilterOption: String = "All Orders"
    @State private var selectedFilter: Int = 0
    @State private var selectedOption: Bool = false
    @State private var selection: Int?
    var orders: [Dispatch] {
        switch selectedFilter {
        case OrderStatus.successful.rawValue:
            return orderData.successfulOrders
        case OrderStatus.partial.rawValue:
            return orderData.partialOrders
        case OrderStatus.failed.rawValue:
            return orderData.failedOrders
        default:
            return orderData.allOrders
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center){
                VStack (alignment: .center,content: {
                    Picker("", selection: $selectedIndex) {
                        Text("List").tag(0)
                        Text("Map").tag(1)
                        
                    }
                    .pickerStyle(.segmented)
                }).frame(width: 200)
                    .onAppear(perform: {
                        let addressList = orderData.dispatches.compactMap({$0.dispatchGuide?.address})
                        self.locations = createLocations(from: addressList)
                    })
               
                
                if selectedIndex == 0 {
                    HStack {
                        VStack(alignment: .leading,spacing: 10,content: {
                            Text("Select Cretirea")
                                .font(.caption2)
                            Text(selectedFilterOption)
                                .font(.caption)
                                .padding(4)
                        })
                        Spacer()
                        Image(systemName: "play.fill")
                            .rotationEffect(.degrees(90))
                            .padding(4).onTapGesture {
                                selectedOption.toggle()
                            }
                    }
                    .padding(8)
                    .shadow(radius: 5)
                    .cornerRadius(4.0)
                    .border(.gray, width: 1)
                    .padding()
                    
                    List {
                        ForEach(self.orders) { order in
                            ListViewCell(item: order)
                                .listRowSeparator(.hidden, edges: .all)
                        }
                    }
                    
                    .frame(maxWidth: .infinity)
                    .padding()
                    .listStyle(.plain)
                } else if selectedIndex == 1 {
                    
                    ZStack(alignment: .leading) {
                        Map(selection: $selection) {
                            ForEach(locations) { location in
                                Marker(location.name, coordinate: location.coordinate)
                                    .tint(.red)
                            }
                        }
                        .onChange(of: selection) {
                            guard let selection else { return }
                            guard let item = locations.first(where: { $0.id == selection }) else { return }
                            guard let dispatch = orderData.dispatches.first(where: { $0.dispatchGuide?.address?.id == Int64(selection)  }) else { return }
                            tappedLocation = dispatch
                            
                        }
                    }
                    if let tapped = self.tappedLocation {
                        
                        VStack {
                            
        
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(tapped.dispatchGuide?.code ?? "0")
                                        .font(.body)
                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                        .frame(maxWidth: .infinity,alignment: .leading)
                                    Text(tapped.dispatchGuide?.address?.name ?? "address not found")
                                        .foregroundStyle(.separator)
                                        .lineLimit(nil)
                                        .multilineTextAlignment(.leading)
                                }.frame(maxWidth: .infinity)
                            }
                            .padding()
                        }
                    }
//                    ZStack(alignment: .leading) {
//                        MapReader { proxy in
//                            Map(interactionModes: [.rotate, .zoom]){
//                                ForEach(locations) { location in
//                                        Marker(location.name, coordinate: location.coordinate)
//                                    }
//                            }.mapStyle(.hybrid(elevation: .realistic))
//                                .onTapGesture { position in
//                                   
//                                    if let coordinate = proxy.convert(position, from: .local) {
//                                        let roundedLatitude = String(format: "%.3f", coordinate.latitude)
//                                        let roundedLongitude = String(format: "%.3f", coordinate.longitude)
//                                        if let tappedLocation = locations.first(where: {
//                                                            String(format: "%.3f", $0.coordinate.latitude) == roundedLatitude &&
//                                                            String(format: "%.3f", $0.coordinate.longitude) == roundedLongitude
//                                                        }) {
//                                                            // Handle tapped Location object
//                                                            print("Tapped location: \(tappedLocation.name)")
//                                                        }
//                                                }
//                                }
//                        }
//                        
//                        
//                      
//                    }
                   
                }
                
            }.sheet(isPresented: $selectedOption) {
                VStack(alignment: .leading) {
                    Text("All Orders").padding()
                        .onTapGesture {
                            selectedFilterOption = "All Orders"
                            selectedFilter = 0
                            selectedOption.toggle()
                        }
                    List {
                        ForEach(OrderStatus.allCases, id: \.self) { status in
                            HStack(alignment: .center) {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(status.color)
                                Text(status.titles)
                            }
                            .listRowSeparator(.hidden, edges: .all)
                            .onTapGesture {
                                selectedFilterOption = status.titles
                                selectedFilter = status.rawValue
                                selectedOption.toggle()
                            }
                        }
                    }
                    .listStyle(.plain)
                }
                .presentationDetents([.height(200)])
            }
            
        }
    }
    
    func createLocations(from addresses: [Address]) -> [Location] {
            var locations: [Location] = []
            for address in addresses {
                guard let latitude = address.latitude, let longitude = address.longitude else { continue }
                let coordinate = CLLocationCoordinate2D(latitude: Double(latitude) ?? 0.0,
                                                        longitude: Double(longitude) ?? 0.0)
                let location = Location(id: Int(address.id), name: address.name ?? "", coordinate: coordinate)
                locations.append(location)
            }
            return locations
        }
    
    
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
