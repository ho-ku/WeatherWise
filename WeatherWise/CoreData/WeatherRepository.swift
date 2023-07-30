//
//  WeatherRepository.swift
//  WeatherWise
//
//  Created by Денис Андриевский on 30.07.2023.
//

import Foundation
import CoreData

protocol AnyWeatherRepository {
    
    /// Method to add the new locattion to a CoreData database
    func add(_ location: WeatherLocation) throws
    
    /// Method to delete location from the CoreData database
    func delete(_ location: WeatherLocationMO) throws
}

final class WeatherRepository: AnyWeatherRepository {
    
    // MARK: - Properties
    
    private let persistenceController: PersistenceController
    private var viewContext: NSManagedObjectContext {
        persistenceController.container.viewContext
    }
    
    // MARK: - Init
    
    init(
        persistenceController: PersistenceController = .shared
    ) {
        self.persistenceController = persistenceController
    }
    
    // MARK: - Methods
    
    func add(_ location: WeatherLocation) throws {
        let newLocationMO = WeatherLocationMO(context: viewContext)
        
        newLocationMO.id = location.id
        newLocationMO.timestamp = Date()
        newLocationMO.title = location.title
        newLocationMO.lat = location.coordinate.latitude
        newLocationMO.lon = location.coordinate.longitude
        
        try viewContext.save()
    }
    
    func delete(_ location: WeatherLocationMO) throws {
        viewContext.delete(location)
        try viewContext.save()
    }
}
