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
        static let weatherRepository: AnyWeatherRepository = WeatherRepository()
    }
    
    struct ViewModel {
        static let searchViewModel = SearchViewModel()
        static let weatherListViewModel = WeatherListViewModel(weatherRepository: DB.weatherRepository)
    }
}
