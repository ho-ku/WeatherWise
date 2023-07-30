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
        static let detailsPadding = 24.0
        static let detailsSpacing = 20.0
        static let weatherSpacing = 32.0
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
                        VStack(spacing: Const.weatherSpacing) {
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
                            
                            if viewModel.selectedLocation?.id == location.id {
                                details(for: location)
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
    
    // MARK: - Private Helpers
    
    @ViewBuilder
    private func details(for location: WeatherLocation) -> some View {
        LazyVStack(spacing: Const.detailsSpacing) {
            ForEach(viewModel.metadata(for: location.id).weatherForecast, id: \.date) { forecast in
                HStack {
                    Text(forecast.condition)
                        .font(.system(size: 22))
                        .foregroundColor(.gray)
                        .bold()
                    
                    Spacer()
                    
                    Text("\(forecast.temperature)°")
                        .font(.system(size: 22))
                        .foregroundColor(.black)
                        .bold()
                }
            }
        }
        .padding(.horizontal, Const.detailsPadding)
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
