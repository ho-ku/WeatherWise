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
            temperature: 34,
            weatherCondition: "Cloudy"
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
        
        withAnimation {
            do {
                try viewContext.save()
            } catch {
                print(error)
            }
        }
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
}
