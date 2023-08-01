//
//  WeatherListViewModel.swift
//  WeatherWise
//
//  Created by Денис Андриевский on 30.07.2023.
//

import SwiftUI
import CoreLocation
import WeatherWiseCore

final class WeatherListViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var selectedLocation: WeatherLocation?
    @Published var locationsMetadata: [String: WeatherLocation.Metadata] = [:]
    @Published var errorTitle: String?
    
    // Private properties
    private let weatherRepository: AnyWeatherRepository
    private let locationRepository: AnyLocationRepository
    private let forecastAPI: AnyForecastAPI
    
    // MARK: - Init
    
    init(
        weatherRepository: AnyWeatherRepository,
        locationRepository: AnyLocationRepository,
        forecastAPI: AnyForecastAPI
    ) {
        self.weatherRepository = weatherRepository
        self.locationRepository = locationRepository
        self.forecastAPI = forecastAPI
    }
    
    // MARK: - Methods
    
    func refreshMetadata(for locations: [WeatherLocation]) {
        locations.forEach(fetchMetadata(for:))
    }
    
    /// Method to add a new location if it does not exist yet
    func add(_ location: WeatherLocation, locations: [WeatherLocation]) {
        guard !locations.contains(where: { $0.id == location.id }) else { return }
        withAnimation {
            do {
                try weatherRepository.add(location)
                fetchMetadata(for: location)
            } catch {
                errorTitle = (error as NSError).description
            }
        }
    }
    
    /// Method to delete location from db
    func delete(_ locationMO: WeatherLocationMO) {
        withAnimation {
            do {
                try weatherRepository.delete(locationMO)
            } catch {
                errorTitle = (error as NSError).description
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
    
    // MARK: - Private Helpers
    
    private func fetchMetadata(for location: WeatherLocation) {
        Task {
            do {
                let forecast = try await forecastAPI.forecast(
                    coordinate: (
                        "\(location.coordinate.latitude)",
                        "\(location.coordinate.longitude)"
                    )
                )
                await MainActor.run {
                    locationsMetadata[location.id] = .init(
                        weatherForecast: forecast.map { .init(
                            date: $0.date,
                            temperature: Int($0.temperature),
                            condition: $0.condition
                        ) }
                    )
                }
            } catch {
                errorTitle = (error as NSError).description
            }
        }
    }
}
