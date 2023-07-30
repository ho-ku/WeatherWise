//
//  ModuleFactory.swift
//  WeatherWise
//
//  Created by Денис Андриевский on 30.07.2023.
//

import Foundation

struct ModuleFactory {
    
    private init() {}
    
    struct DB {
        static let locationRepository: AnyLocationRepository = LocationRepository()
        static let weatherRepository: AnyWeatherRepository = WeatherRepository()
    }
    
    struct ViewModel {
        static let searchViewModel = SearchViewModel(locationRepository: DB.locationRepository)
        static let weatherListViewModel = WeatherListViewModel(
            weatherRepository: DB.weatherRepository,
            locationRepository: DB.locationRepository
        )
    }
}
