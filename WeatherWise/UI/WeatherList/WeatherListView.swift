//
//  WeatherListView.swift
//  WeatherWise
//
//  Created by Денис Андриевский on 28.07.2023.
//

import SwiftUI

struct WeatherListView: View {
    
    private struct Const {
        static let imageSize = 28.0
    }

    // MARK: - Properties
    
    var locations: [WeatherLocation] {
         locationsFetchRequest.map { .init(modelObject: $0) }
    }
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WeatherLocationMO.timestamp, ascending: true)],
        animation: .default) private var locationsFetchRequest: FetchedResults<WeatherLocationMO>
    
    @StateObject private var viewModel: WeatherListViewModel = .init()
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(locations, id: \.title) { location in
                        WeatherCell(
                            location: location,
                            metadata: viewModel.metadata(for: location.id),
                            timeAction: { await viewModel.time(in: location) }
                        )
                            .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
            .navigationTitle(Strings.title)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SearchView {
                            viewModel.add($0, locations: locations)
                        }
                    } label: {
                        Image.plusCircle
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.blue)
                            .bold()
                            .frame(width: Const.imageSize, height: Const.imageSize)
                    }
                }
            }
        }
        
    }
}

struct WeatherListView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherListView()
    }
}
