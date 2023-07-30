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
    
    private let persistenceController: PersistenceController
    
    // MARK: - Init
    
    init(
        persistenceController: PersistenceController = .shared
    ) {
        self.persistenceController = persistenceController
    }
    
    // MARK: - Methods
    
    func metadata(for id: String) -> WeatherLocation.Metadata {
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
    
    func add(_ location: WeatherLocation, locations: [WeatherLocation]) {
        guard !locations.contains(where: { $0.id == location.id }) else { return }
        let viewContext = persistenceController.container.viewContext
        let newLocationMO = WeatherLocationMO(context: viewContext)
        
        newLocationMO.id = location.id
        newLocationMO.timestamp = .init()
        newLocationMO.title = location.title
        newLocationMO.lat = location.coordinate.latitude
        newLocationMO.lon = location.coordinate.longitude
        
        saveContext()
    }
    
    func delete(_ locationMO: WeatherLocationMO) {
        let viewContext = persistenceController.container.viewContext
        viewContext.delete(locationMO)
        saveContext()
        withAnimation { selectedLocation = nil }
    }
    
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
    
    // MARK: - Private helpers
    
    private func saveContext() {
        let viewContext = persistenceController.container.viewContext
        withAnimation {
            do {
                try viewContext.save()
            } catch {
                print(error)
            }
        }
    }
}
