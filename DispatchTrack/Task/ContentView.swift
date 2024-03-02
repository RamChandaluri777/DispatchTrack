//
//  ContentView.swift
//  DispatchTrack
//
//  Created by mohan chandaluri on 29/02/24.
//

import SwiftUI
import CoreData

enum OrderStatus: String, CaseIterable {
    case successful = "Successful Orders"
    case partial = "Partial Orders"
    case failed = "Failed Orders"
    
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
    @State private var selectedOption: Bool = false

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
                    ForEach(orderData.dispatches) { order in
                        ListViewCell(item: order)
                            .listRowSeparator(.hidden, edges: /*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        
                    }
                }.frame(maxWidth: .infinity)
                    .padding()
                    .listStyle(.plain)
                
            }.sheet(isPresented: $selectedOption) {
                VStack(alignment: .leading) {
                    Text("All Orders").padding()
                    
                    List {
                        ForEach(OrderStatus.allCases, id: \.self) { status in
                            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, content: {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(status.color)
                                Text(status.rawValue)
                            }).listRowSeparator(.hidden, edges: /*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                                .onTapGesture {
                                    selectedFilterOption = status.rawValue
                                    selectedOption.toggle()
                                }
                                       }
                       
                    }.listStyle(.plain)
                }.presentationDetents([.medium])
                    
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
