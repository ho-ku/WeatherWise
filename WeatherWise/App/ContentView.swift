//
//  ContentView.swift
//  WeatherWise
//
//  Created by Денис Андриевский on 24.07.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        WeatherListView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
