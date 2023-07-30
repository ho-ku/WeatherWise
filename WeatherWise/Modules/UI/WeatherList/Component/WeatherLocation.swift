//
//  WeatherLocation.swift
//  WeatherWise
//
//  Created by Денис Андриевский on 28.07.2023.
//

import Foundation
import CoreLocation

/// A container object for a location where weather forecast should be done
final class WeatherLocation {
    
    // MARK: - Properties
    
    /// Location identifier
    let id: String
    
    /// Location title
    let title: String
    
    /// Location coordinate
    let coordinate: CLLocationCoordinate2D
    
    // MARK: - Init
    
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
    
    // MARK: - DS
    
    /// Location metadata
    struct Metadata {
        
        /// Weather forecast unit
        struct WeatherForecast {
            
            /// Date of a forecast
            let date: Date
            
            /// Weather temperature
            let temperature: Int
            
            /// Weather condition description
            let condition: String
        }
        
        /// A list of future forecasts
        let weatherForecast: [WeatherForecast]
        
        /// Current weather temperature
        var temperature: Int? { weatherForecast.first?.temperature }
        
        /// Current weather condition description
        var weatherCondition: String? { weatherForecast.first?.condition }
    }
}
