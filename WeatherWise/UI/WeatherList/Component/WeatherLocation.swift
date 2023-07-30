//
//  WeatherLocation.swift
//  WeatherWise
//
//  Created by Денис Андриевский on 28.07.2023.
//

import Foundation
import CoreLocation

final class WeatherLocation {
    let id: String
    let title: String
    let coordinate: CLLocationCoordinate2D
    
    init(
        id: String,
        title: String,
        coordinate: CLLocationCoordinate2D) {
            self.id = id
            self.title = title
            self.coordinate = coordinate
        }
    
    init(modelObject: WeatherLocationMO) {
        self.id = modelObject.id ?? ""
        self.title = modelObject.title ?? ""
        self.coordinate = .init(latitude: modelObject.lat, longitude: modelObject.lon)
    }
    
    struct Metadata {
        struct WeatherForecast {
            let date: Date
            let temperature: Int
            let condition: String
        }
        
        let weatherForecast: [WeatherForecast]
        
        var temperature: Int? { weatherForecast.first?.temperature }
        var weatherCondition: String? { weatherForecast.first?.condition }
    }
}
