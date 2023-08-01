//
//  WeatherListViewModelTests.swift
//  WeatherWiseTests
//
//  Created by Денис Андриевский on 01.08.2023.
//

import XCTest
@testable import WeatherWiseCore
@testable import WeatherWise
import CoreLocation

final class WeatherListViewModelTests: XCTestCase {
    
    func testRefreshSuccess() async {
        // GIVEN
        let forecast = [Forecast(date: .init(), temperature: 30, condition: "Condition")]
        let api = APIMock(expectedResult: .success(forecast))
        let expectation = expectation(description: "Expect API to return value")
        api.expectation = expectation
        let sut = makeSUT(api: api)
        let location = WeatherLocation(id: "1", title: "", coordinate: .init())
        // WHEN
        sut.refreshMetadata(for: [location])
        await fulfillment(of: [expectation])
        // THEN
        XCTAssertEqual(sut.locationsMetadata[location.id]?.weatherCondition, "Condition")
    }
    
    func testRefreshError() async {
        // GIVEN
        let api = APIMock(expectedResult: .failure("some error"))
        let expectation = expectation(description: "Expect API to return value")
        api.expectation = expectation
        let sut = makeSUT(api: api)
        let location = WeatherLocation(id: "1", title: "", coordinate: .init())
        // WHEN
        sut.refreshMetadata(for: [location])
        await fulfillment(of: [expectation])
        // THEN
        XCTAssertNil(sut.locationsMetadata[location.id])
        XCTAssertNotNil(sut.errorTitle)
    }
    
    func testAddSuccess() {
        // GIVEN
        let weatherRepository = WeatherRepositoryMock()
        let sut = makeSUT(weatherRepository: weatherRepository)
        let location = WeatherLocation(id: "1", title: "", coordinate: .init())
        // WHEN
        sut.add(location, locations: [])
        // THEN
        XCTAssertTrue(weatherRepository.isAddTriggered)
    }
    
    func testAddRepetition() {
        // GIVEN
        let weatherRepository = WeatherRepositoryMock()
        let sut = makeSUT(weatherRepository: weatherRepository)
        let location = WeatherLocation(id: "1", title: "", coordinate: .init())
        // WHEN
        sut.add(location, locations: [location])
        // THEN
        XCTAssertFalse(weatherRepository.isAddTriggered)
    }
    
    func testAddFailure() {
        // GIVEN
        let weatherRepository = WeatherRepositoryMock()
        weatherRepository.error = "some error"
        let sut = makeSUT(weatherRepository: weatherRepository)
        let location = WeatherLocation(id: "1", title: "", coordinate: .init())
        // WHEN
        sut.add(location, locations: [])
        // THEN
        XCTAssertNotNil(sut.errorTitle)
    }
    
    func testDeleteSuccess() {
        // GIVEN
        let weatherRepository = WeatherRepositoryMock()
        let sut = makeSUT(weatherRepository: weatherRepository)
        // WHEN
        sut.delete(.init())
        // THEN
        XCTAssertTrue(weatherRepository.isDeleteTriggered)
    }
    
    func testDeleteFailure() {
        // GIVEN
        let weatherRepository = WeatherRepositoryMock()
        weatherRepository.error = "some error"
        let sut = makeSUT(weatherRepository: weatherRepository)
        // WHEN
        sut.delete(.init())
        // THEN
        XCTAssertNotNil(sut.errorTitle)
    }
    
    // MARK: - Private Helpers
    
    private func makeSUT(
        weatherRepository: AnyWeatherRepository = WeatherRepositoryMock(),
        locationRepository: AnyLocationRepository = LocationRepositoryMock(),
        api: AnyForecastAPI = APIMock(expectedResult: .success([]))
    ) -> WeatherListViewModel {
        .init(weatherRepository: weatherRepository, locationRepository: locationRepository, forecastAPI: api)
    }
    
}

// MARK: - Mocks

private extension WeatherListViewModelTests {
    final class WeatherRepositoryMock: AnyWeatherRepository {
        var error: Error?
        var isAddTriggered = false
        var isDeleteTriggered = false
        
        func add(_ location: WeatherWise.WeatherLocation) throws {
            if let error { throw error }
            isAddTriggered = true
        }
        
        func delete(_ location: WeatherWise.WeatherLocationMO) throws {
            if let error { throw error }
            isDeleteTriggered = true
        }
    }
    
    final class LocationRepositoryMock: AnyLocationRepository {
        var expectedTimeZone: TimeZone?
        
        func timeZone(in coordinate: CLLocationCoordinate2D) async -> TimeZone? {
            expectedTimeZone
        }
        
        func search(_ term: String) async -> [(location: WeatherWise.WeatherLocation, description: String)] { [] }
    }
    
    final class APIMock: AnyForecastAPI {
        
        var expectedResult: Result<[Forecast], Error>
        var expectation: XCTestExpectation?
        
        init(expectedResult: Result<[Forecast], Error>) {
            self.expectedResult = expectedResult
        }
        
        func forecast(coordinate: (lat: String, lon: String)) async throws -> [WeatherWiseCore.Forecast] {
            defer { expectation?.fulfill() }
            switch expectedResult {
            case .success(let success):
                return success
            case .failure(let failure):
                throw failure
            }
        }
    }
}
