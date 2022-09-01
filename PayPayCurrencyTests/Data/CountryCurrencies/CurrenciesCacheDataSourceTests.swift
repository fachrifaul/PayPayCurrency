//
//  CurrenciesCacheDataSourceTests.swift
//  PayPayCurrencyTests
//
//  Created by Fachri Febrian on 17/08/2022.
//

@testable import PayPayCurrency
import XCTest

class CurrenciesCacheDataSourceTests: XCTestCase {
    
    // MARK: - Subject under test
    var userDefaults: UserDefaults!
    var sut: CurrenciesCacheDataSource!
    
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
        sut = CurrenciesCacheDataSource(userDefaults: userDefaults)
    }
    
    func resetCacheCurrencies() {
        userDefaults.removePersistentDomain(forName: #file)
        sut = nil
    }
    
    
    // MARK: - Test Cases
    
    func testFetchCurrenciesShouldReturnEmpty() {
        // Given
        
        // When
        let currencies = sut.fetchCurrencies()
        
        // Then
        XCTAssertEqual(currencies, [:], "fetchCurrencies() should return empty currencies")
        XCTAssertEqual(currencies.count, 0, "fetchCurrencies() count equals zero")
    }
    
    func testFetchCurrenciesShouldReturnListCurrencies() {
        // Given
        let givenCurrencies = [
            "IDR": "Indonesian Rupiah",
            "USD": "United States Dollar",
        ]
        sut.createCurrencies(currencies: givenCurrencies)
        
        // When
        let currencies = sut.fetchCurrencies()
        
        // Then
        XCTAssertEqual(currencies, givenCurrencies, "fetchCurrencies() should return list currencies")
        XCTAssertEqual(currencies.count, 2, "fetchCurrencies() count equals two")
    }
    
}
