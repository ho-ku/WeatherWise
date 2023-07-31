//
//  ModuleFactory.swift
//  WeatherWise
//
//  Created by Денис Андриевский on 30.07.2023.
//

import Foundation
import WeatherWiseCore

struct ModuleFactory {
    
    private init() {}
    
    struct Core {
        static let locationRepository: AnyLocationRepository = LocationRepository()
        static let weatherRepository: AnyWeatherRepository = WeatherRepository()
        static let urlSession: URLSession = .shared
        static let decoder = JSONDecoder()
    }
    
    struct ViewModel {
        static let searchViewModel = SearchViewModel(locationRepository: Core.locationRepository)
        static let weatherListViewModel = WeatherListViewModel(
            weatherRepository: Core.weatherRepository,
            locationRepository: Core.locationRepository,
            forecastAPI: ForecastBuilder(
                urlSession: Core.urlSession,
                decoder: Core.decoder
            )
            .withAPIKey(Config.apiKey)
            .build()
        )
    }
}
