//
//  LocationRepository.swift
//  WeatherWise
//
//  Created by Денис Андриевский on 30.07.2023.
//

import CoreLocation
import MapKit

protocol AnyLocationRepository {
    
    /// Method that returns a timezone in specified coordinate
    func timeZone(in coordinate: CLLocationCoordinate2D) async -> TimeZone?
    
    /// Method to search for location with specific search term
    func search(_ term: String) async -> [(location: WeatherLocation, description: String)]
}

final class LocationRepository: AnyLocationRepository {
    func timeZone(in coordinate: CLLocationCoordinate2D) async -> TimeZone? {
        let clLocation = CLLocation(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
        let geocoder = CLGeocoder()
        let placemarks = try? await geocoder.reverseGeocodeLocation(clLocation)
        return placemarks?.first?.timeZone
    }
    
    func search(_ term: String) async -> [(location: WeatherLocation, description: String)] {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = term
        let search = MKLocalSearch(request: request)
        guard let response = try? await search.start() else { return [] }
        return response.mapItems.map {
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
