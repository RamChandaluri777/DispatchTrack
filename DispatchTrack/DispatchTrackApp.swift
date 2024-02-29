//
//  DispatchTrackApp.swift
//  DispatchTrack
//
//  Created by mohan chandaluri on 29/02/24.
//

import SwiftUI

@main
struct DispatchTrackApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
