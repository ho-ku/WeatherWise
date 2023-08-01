//
//  SearchViewModelTests.swift
//  WeatherWiseTests
//
//  Created by Денис Андриевский on 01.08.2023.
//

import XCTest
import CoreLocation
@testable import WeatherWise

final class SearchViewModelTests: XCTestCase {
    
    // MARK: - Properties
    
    private let locationRepository = LocationRepositoryMock()
    
    // MARK: - Tests
    
    func testSearch() async throws {
        // GIVEN
        let expectation = expectation(description: "Waiting for location repository to return items")
        locationRepository.items = [(WeatherLocation(id: "2", title: "", coordinate: .init()), "")]
        locationRepository.expectation = expectation
        let sut = makeSUT()
        // WHEN
        sut.searchText = "new search"
        await fulfillment(of: [expectation])
        // THEN
        XCTAssertEqual(sut.foundWeatherObjects.count, locationRepository.items.count)
    }
    
    func testSearchEmptySearchText() async throws {
        // GIVEN
        locationRepository.items = [(WeatherLocation(id: "2", title: "", coordinate: .init()), "")]
        let sut = makeSUT()
        // WHEN
        sut.searchText = ""
        // THEN
        XCTAssertNil(sut.searchTask)
    }
   
    // MARK: - Private Helpers
    
    private func makeSUT() -> SearchViewModel {
        .init(locationRepository: locationRepository)
    }

}

// MARK: - Mocks

private extension SearchViewModelTests {
    final class LocationRepositoryMock: AnyLocationRepository {
        var items: [(location: WeatherWise.WeatherLocation, description: String)] = []
        var expectation: XCTestExpectation?
        
        func timeZone(in coordinate: CLLocationCoordinate2D) async -> TimeZone? { nil }
        
        func search(_ term: String) async -> [(location: WeatherWise.WeatherLocation, description: String)] {
            defer { expectation?.fulfill() }
            return items
        }
    }
}
