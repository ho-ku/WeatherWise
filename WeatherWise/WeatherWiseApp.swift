//
//  WeatherWiseApp.swift
//  WeatherWise
//
//  Created by Денис Андриевский on 24.07.2023.
//

import SwiftUI

@main
struct WeatherWiseApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
