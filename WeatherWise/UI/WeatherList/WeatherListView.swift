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
    
    @StateObject private var viewModel = ModuleFactory.ViewModel.weatherListViewModel
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(locations, id: \.title) { location in
                        if viewModel.selectedLocation?.id == location.id || viewModel.selectedLocation == nil {
                            WeatherCell(
                                location: location,
                                metadata: viewModel.metadata(for: location.id),
                                timeAction: { await viewModel.time(in: location) }
                            )
                                .padding(.horizontal)
                                .onTapGesture {
                                    withAnimation(.easeInOut) {
                                        viewModel.selectedLocation = viewModel.selectedLocation == nil ? location : nil
                                    }
                                }
                        }
                    }
                }
                .padding(.top)
            }
            .navigationTitle(Strings.title)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if viewModel.selectedLocation == nil {
                        addButton
                    } else {
                        deleteButton
                    }
                }
            }
        }
    }
    
    private var addButton: some View {
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
    
    private var deleteButton: some View {
        Button {
            guard let location = locationsFetchRequest.first(where: { $0.id == viewModel.selectedLocation?.id }) else { return }
            viewModel.delete(location)
        } label: {
            Image.trash
                .resizable()
                .scaledToFit()
                .foregroundColor(.red)
                .bold()
                .frame(width: Const.imageSize, height: Const.imageSize)
        }

    }
}

struct WeatherListView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherListView()
    }
}
