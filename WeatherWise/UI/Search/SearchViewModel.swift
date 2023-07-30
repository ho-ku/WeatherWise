//
//  SearchViewModel.swift
//  WeatherWise
//
//  Created by Денис Андриевский on 30.07.2023.
//

import Combine
import MapKit

final class SearchViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var searchText: String = "" {
        didSet {
            addDelayedSearchTask()
        }
    }
    @Published var foundWeatherObjects: [
        (location: WeatherLocation, description: String)
    ] = []
    
    // Private properties
    private var searchTask: Task<Void, Error>?
    
    // MARK: - Methods
    
    /// Method that creates a search task that will be executed after a delay
    func addDelayedSearchTask(delay: UInt64 = 1_000_000_000) {
        searchTask?.cancel()
        guard !searchText.isEmpty else { return }
        searchTask = Task {
            try await Task.sleep(nanoseconds: delay)
            await search()
        }
    }
    
    func search() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        let search = MKLocalSearch(request: request)
        guard let response = try? await search.start() else { return }
        await MainActor.run {
            self.foundWeatherObjects = response.mapItems.map {
                (
                    .init(
                        id: "\(String(describing: $0.name)) - \($0.placemark.coordinate)",
                        title: $0.name ?? "",
                        coordinate: $0.placemark.coordinate
                    ),
                    $0.placemark.title ?? ""
                )
            }
        }
    }
}
