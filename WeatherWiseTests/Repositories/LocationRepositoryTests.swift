//
//  LocationRepositoryTests.swift
//  WeatherWiseTests
//
//  Created by Денис Андриевский on 01.08.2023.
//

import XCTest
import MapKit
@testable import WeatherWise

final class LocationRepositoryTests: XCTestCase {

    func testSearch() async {
        // GIVEN
        let sut = makeSUT()
        // WHEN
        _ = await sut.search("")
        // THEN
        XCTAssertTrue(Searchable.searchBegan)
    }
    
    func testTimeZone() async {
        // GIVEN
        let londonCoordinate = CLLocationCoordinate2D(latitude: 51.509865, longitude: -0.118092)
        let viennaCoordinate = CLLocationCoordinate2D(latitude: 48.210033, longitude: 16.363449)
        let sut = makeSUT()
        // WHEN
        let londonTimeZone = await sut.timeZone(in: londonCoordinate)
        let viennaTimeZone = await sut.timeZone(in: viennaCoordinate)
        // THEN
        XCTAssertEqual(londonTimeZone?.identifier, "Europe/London")
        XCTAssertEqual(viennaTimeZone?.identifier, "Europe/Vienna")
    }
    
    // MARK: - Private Helpers
    
    private func makeSUT() -> AnyLocationRepository {
        LocationRepository(searchableType: Searchable.self)
    }

}

// MARK: - Mocks

private extension LocationRepositoryTests {
    final class Searchable: AnyMapSearchable {
        static var searchBegan = false
        
        init(request: MKLocalSearch.Request) {}
        
        func start() async throws -> MKLocalSearch.Response {
            Searchable.searchBegan = true
            return .init()
        }
    }
}
