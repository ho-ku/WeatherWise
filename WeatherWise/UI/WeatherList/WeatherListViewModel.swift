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
    
    private let weatherRepository: AnyWeatherRepository
    
    // MARK: - Init
    
    init(weatherRepository: AnyWeatherRepository) {
        self.weatherRepository = weatherRepository
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
        let clLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let geocoder = CLGeocoder()
        let placemarks = try? await geocoder.reverseGeocodeLocation(clLocation)
        guard let placemark = placemarks?.first else { return "" }

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = placemark.timeZone
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: .now)
    }
}
