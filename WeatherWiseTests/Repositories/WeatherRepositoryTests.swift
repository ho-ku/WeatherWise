//
//  WeatherRepositoryTests.swift
//  WeatherWiseTests
//
//  Created by Денис Андриевский on 01.08.2023.
//

import XCTest
@testable import WeatherWise
import CoreData

final class WeatherRepositoryTests: XCTestCase {

    func testAdd() throws {
        // GIVEN
        let location = WeatherLocation(id: "1", title: "1", coordinate: .init(latitude: .zero, longitude: .zero))
        let viewContext = ViewContextMock(concurrencyType: .mainQueueConcurrencyType)
        let sut = makeSUT(viewContext: viewContext)
        // WHEN
        try sut.add(location)
        // THEN
        XCTAssertTrue(viewContext.isSaveTriggered)
    }
    
    func testAddWithError() throws {
        // GIVEN
        let location = WeatherLocation(id: "1", title: "1", coordinate: .init(latitude: .zero, longitude: .zero))
        let viewContext = ViewContextErrorMock(concurrencyType: .mainQueueConcurrencyType)
        let sut = makeSUT(viewContext: viewContext)
        // WHEN
        do {
            try sut.add(location)
            // THEN
            XCTFail("Expected error")
        } catch { }
    }
    
    func testDelete() throws {
        // GIVEN
        let viewContext = ViewContextMock(concurrencyType: .mainQueueConcurrencyType)
        let sut = makeSUT(viewContext: viewContext)
        // WHEN
        try sut.delete(.init())
        // THEN
        XCTAssertTrue(viewContext.isDeleteTriggered)
    }
    
    // MARK: - Private Helpers
    
    private func makeSUT(viewContext: NSManagedObjectContext) -> AnyWeatherRepository {
        WeatherRepository(viewContext: viewContext)
    }
    
}

// MARK: - Mocks

private extension WeatherRepositoryTests {
    final class ViewContextMock: NSManagedObjectContext {
        var isSaveTriggered: Bool = false
        var isDeleteTriggered: Bool = false
        
        override func save() throws {
            isSaveTriggered = true
        }
        
        override func delete(_ object: NSManagedObject) {
            isDeleteTriggered = true
        }
    }
    
    final class ViewContextErrorMock: NSManagedObjectContext {
        override func delete(_ object: NSManagedObject) {}
        
        override func save() throws {
            throw "some error"
        }
    }
}
