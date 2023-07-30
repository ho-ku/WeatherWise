//
//  WeatherListViewModel.swift
//  WeatherWise
//
//  Created by Денис Андриевский on 30.07.2023.
//

import SwiftUI
import CoreLocation

final class WeatherListViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var selectedLocation: WeatherLocation?
    
    // Private properties
    private let weatherRepository: AnyWeatherRepository
    private let locationRepository: AnyLocationRepository
    
    // MARK: - Init
    
    init(
        weatherRepository: AnyWeatherRepository,
        locationRepository: AnyLocationRepository
    ) {
        self.weatherRepository = weatherRepository
        self.locationRepository = locationRepository
    }
    
    // MARK: - Methods
    
    func metadata(for id: String) -> WeatherLocation.Metadata { // TODO: - Replace with the real data
        .init(
            weatherForecast: [
                .init(
                    date: .init(),
                    temperature: 30,
                    condition: "Rain"
                ),
                .init(
                    date: .init().addingTimeInterval(10800),
                    temperature: 29,
                    condition: "Cloudy"
                ),
                .init(
                    date: .init().addingTimeInterval(21600),
                    temperature: 20,
                    condition: "Norm"
                ),
                .init(
                    date: .init().addingTimeInterval(32400),
                    temperature: 21,
                    condition: "Rain"
                ),
                .init(
                    date: .init().addingTimeInterval(43200),
                    temperature: 40,
                    condition: "Rain"
                ),
                .init(
                    date: .init().addingTimeInterval(54000),
                    temperature: 19,
                    condition: "Rain"
                ),
                .init(
                    date: .init().addingTimeInterval(64800),
                    temperature: 50,
                    condition: "Rain"
                )
            ]
        )
    }
    
    /// Method to add a new location if it does not exist yet
    func add(_ location: WeatherLocation, locations: [WeatherLocation]) {
        guard !locations.contains(where: { $0.id == location.id }) else { return }
        withAnimation {
            do {
                try weatherRepository.add(location)
            } catch {
                print(error)
            }
        }
    }
    
    /// Method to delete location from db
    func delete(_ locationMO: WeatherLocationMO) {
        withAnimation {
            do {
                try weatherRepository.delete(locationMO)
            } catch {
                print(error)
            }
            selectedLocation = nil
        }
    }
    
    /// Method to get current time string in specific location
    func time(in location: WeatherLocation) async -> String {
        guard let timeZone = await locationRepository.timeZone(in: location.coordinate) else { return "" }
        let dateFormatter = DateFormatter.hourMinute
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: .now)
    }
}
