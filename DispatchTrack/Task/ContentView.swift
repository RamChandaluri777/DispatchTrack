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

struct ContentView: View {
    @ObservedObject var orderData = ReadData()
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @State private var selectedIndex = 0
    @State private var selectedFilterOption: String = "All Orders"
    @State private var selectedFilter: Int = 0
    @State private var selectedOption: Bool = false
    
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
                    // Show Apple Maps SwiftUI view
                    // Replace Text("Apple Maps SwiftUI") with your Apple Maps SwiftUI view
                    Text("Apple Maps SwiftUI")
                        .padding()
                }
                
            }.sheet(isPresented: $selectedOption) {
                VStack(alignment: .leading) {
                    Text("All Orders").padding()
                    
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
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
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
