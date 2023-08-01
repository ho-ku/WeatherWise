//
//  SearchViewModel.swift
//  WeatherWise
//
//  Created by Денис Андриевский on 30.07.2023.
//

import Combine

final class SearchViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var searchText: String = "" {
        didSet { addDelayedSearchTask() }
    }
    
    @Published var foundWeatherObjects: [
        (location: WeatherLocation, description: String)
    ] = []
    
    // Private properties
    private(set) var searchTask: Task<Void, Error>?
    private let locationRepository: AnyLocationRepository
    
    // MARK: - Init
    
    init(locationRepository: AnyLocationRepository) {
        self.locationRepository = locationRepository
    }
    
    // MARK: - Methods
    
    /// Method that creates a search task that will be executed after a delay
    private func addDelayedSearchTask(delay: UInt64 = 1_000_000_000) {
        searchTask?.cancel()
        guard !searchText.isEmpty else { return }
        searchTask = Task {
            try await Task.sleep(nanoseconds: delay)
            await search()
        }
    }
    
    /// Method that performs search with a specific search term
    @MainActor
    private func search() async {
        foundWeatherObjects = await locationRepository.search(searchText)
    }
}
