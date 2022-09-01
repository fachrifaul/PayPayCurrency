//
//  LatestRateCacheDataSourceTests.swift
//  PayPayCurrencyTests
//
//  Created by Fachri Febrian on 17/08/2022.
//

@testable import PayPayCurrency
import XCTest

class LatestRateCacheDataSourceTests: XCTestCase {
    
    // MARK: - Subject under test
    var userDefaults: UserDefaults!
    var sut: LatestRateCacheDataSource!
    
    // MARK: - Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupOrdersMemStore()
    }
    
    override func tearDown() {
        resetCacheCurrencies()
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupOrdersMemStore() {
        userDefaults = UserDefaults(suiteName: #file)
        sut = LatestRateCacheDataSource(userDefaults: userDefaults)
    }
    
    func resetCacheCurrencies() {
        userDefaults.removePersistentDomain(forName: #file)
        sut = nil
    }
    
    
    // MARK: - Test Cases
    
    func testFetchRatesShouldReturnEmptyRates() {
        // Given
        
        // When
        let rates = sut.fetchLatestConversionRate()
        
        // Then
        XCTAssertEqual(rates, [:], "fetchLatestConversionRate() should return empty rates")
        XCTAssertEqual(rates.count, 0, "fetchLatestConversionRate() count equals zero")
    }
    
    func testFetchRatesShouldReturnListRates() {
        // Given
        let givenRates = [
            "AED": 3.673045,
            "AFN": 88.673585,
            "IDR": 14773.140453,
        ]
        sut.createLatestConversionRate(rates: givenRates)
        
        // When
        let rates = sut.fetchLatestConversionRate()
        
        // Then
        XCTAssertEqual(rates, givenRates, "fetchLatestConversionRate() should return list rates")
        XCTAssertEqual(rates.count, 3, "fetchLatestConversionRate() count equals three")
    }
    
}

