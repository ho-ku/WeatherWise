//
//  ForecastUnit.swift
//  WeatherWiseCore
//
//  Created by Денис Андриевский on 31.07.2023.
//

import Foundation

/// Weather forecast unit
public struct Forecast {
    
    /// Date of a forecast
    public let date: Date
    
    /// Weather temperature
    public let temperature: Double
    
    /// Weather condition description
    public let condition: String
}

extension Forecast {
    init(_ decodable: ForecastUnit) {
        self.date = decodable.date
        self.temperature = decodable.main.temp
        self.condition = decodable.weather.first?.main ?? ""
    }
}

extension Forecast {
    struct ForecastDecodable: Decodable {
        let list: [ForecastUnit]
    }
    
    struct ForecastUnit: Decodable {
        enum CodingKeys: String, CodingKey {
            case date = "dt"
            case main, weather
        }
        
        let date: Date
        let main: ForecastMain
        let weather: [ForecastWeather]
    }
    
    struct ForecastMain: Decodable {
        let temp: Double
    }
    
    struct ForecastWeather: Decodable {
        let main: String
    }
}
