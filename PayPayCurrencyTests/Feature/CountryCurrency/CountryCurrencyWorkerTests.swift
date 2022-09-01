//
//  CountryCurrencyWorkerTests.swift
//  PayPayCurrencyTests
//
//  Created by Fachri Febrian on 17/08/2022.
//

@testable import PayPayCurrency
import XCTest

class CountryCurrencyWorkerTests: XCTestCase {
    
    // MARK: - Subject under test
    var limitBandwith: LimitBandwith!
    var userDefaults: UserDefaults!
    var sut: CountryCurrencyWorker!
    
    // MARK: - Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupCountryCurrencyWorker()
    }
    
    override func tearDown() {
        super.tearDown()
        userDefaults.removePersistentDomain(forName: #file)
        sut = nil
    }
    
    // MARK: - Test setup
    
    func setupCountryCurrencyWorker() {
        userDefaults = UserDefaults(suiteName: #file)
        limitBandwith = LimitBandwith(userDefaults: userDefaults)
        sut = CountryCurrencyWorker(
            cacheDataSource: CurrenciesCacheDataSourceSpy(),
            apiDataSource: RemoteCurrenciesApiDataSourceSpy()
        )
    }
    
    class CurrenciesCacheDataSourceSpy: CurrenciesCacheDataSource {
        // MARK: Method call expectations
        var createCurrenciesCalled = false
        var fetchCurrenciesCalled = false
        
        var cacheCurrenciesResponse: [String : String] = [:]
        
        // MARK: Spied methods
        override func createCurrencies(currencies: [String : String]) {
            createCurrenciesCalled = true
        }
        
        override func fetchCurrencies() -> [String : String] {
            fetchCurrenciesCalled = true
            return cacheCurrenciesResponse
        }
    }
    
    class RemoteCurrenciesApiDataSourceSpy: CurrenciesApiDataSource {
        // MARK: Method call expectations
        var fetchCurrenciesCalled = false
        
        var currenciesResponse: [String : String] = [:]
        
        // MARK: Spied methods
        override func fetchCurrencies(completion: @escaping ([String : String]) -> Void) {
            fetchCurrenciesCalled = true
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
                completion(self?.currenciesResponse ?? [:])
            }
        }
    }
    
    
    // MARK: - Tests
    
    func testFetchCurrenciesShouldReturnListOfCurrencies_fromRemote() {
        // Given
        let givenRemoteCurrenciesResponse =  [
            "AED": "United Arab Emirates Dirham",
            "AFN": "Afghan Afghani",
            "ALL": "Albanian Lek"
        ]
        let remoteCurrenciesServiceSpy = sut.apiDataSource as! RemoteCurrenciesApiDataSourceSpy
        remoteCurrenciesServiceSpy.currenciesResponse = givenRemoteCurrenciesResponse
        
        let cacheCurrenciesServiceSpy = sut.cacheDataSource as! CurrenciesCacheDataSourceSpy
        
        // When
        var fetchCurrencies = [String: String]()
        let expectation = expectation(description: "Wait for fetchCurrencies() to return")
        sut.fetchCurrencies { currencies in
            fetchCurrencies = currencies
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        
        // Then
        XCTAssertTrue(
            cacheCurrenciesServiceSpy.fetchCurrenciesCalled,
            "Calling fetchCurrencies() should ask the cache for a list of currencies"
        )
        XCTAssertEqual(
            0,
            cacheCurrenciesServiceSpy.cacheCurrenciesResponse.count,
            "fetchCurrencies() should sk the cache to return a empty list of currencies"
        )
        XCTAssertTrue(
            cacheCurrenciesServiceSpy.createCurrenciesCalled,
            "Calling fetchCurrencies() should ask the cache to create new list of currencies"
        )
        
        XCTAssertTrue(
            remoteCurrenciesServiceSpy.fetchCurrenciesCalled,
            "Calling fetchCurrencies() should ask the remote for a list of currencies"
        )
        XCTAssertEqual(
            fetchCurrencies.count,
            givenRemoteCurrenciesResponse.count,
            "fetchCurrencies() should ask the remote to return a list of currencies"
        )
        XCTAssertEqual(
            fetchCurrencies,
            givenRemoteCurrenciesResponse,
            "fetchCurrencies() should ask the remote to return a list of currencies"
        )
    }
    
    func testFetchCurrenciesShouldReturnListOfCurrencies_fromCache() {
        // Given
        let remoteCurrenciesServiceSpy = sut.apiDataSource as! RemoteCurrenciesApiDataSourceSpy
        
        let givenCacheCurrenciesResponse =  [
            "AED": "United Arab Emirates Dirham",
            "AFN": "Afghan Afghani",
            "ALL": "Albanian Lek"
        ]
        let cacheCurrenciesServiceSpy = sut.cacheDataSource as! CurrenciesCacheDataSourceSpy
        cacheCurrenciesServiceSpy.cacheCurrenciesResponse = givenCacheCurrenciesResponse
        
        // When
        var fetchCurrencies = [String: String]()
        let expectation = expectation(description: "Wait for fetchCurrencies() to return")
        sut.fetchCurrencies { currencies in
            fetchCurrencies = currencies
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5.0)
        
        // Then
        XCTAssertTrue(
            cacheCurrenciesServiceSpy.fetchCurrenciesCalled,
            "Calling fetchCurrencies() should ask the cache for a list of currencies"
        )
        XCTAssertEqual(
            givenCacheCurrenciesResponse.count,
            fetchCurrencies.count,
            "fetchCurrencies() should ask the cache to return a list of currencies"
        )
        XCTAssertEqual(
            fetchCurrencies,
            givenCacheCurrenciesResponse,
            "fetchCurrencies() in cache should match list of currencies"
        )
        XCTAssertFalse(
            cacheCurrenciesServiceSpy.createCurrenciesCalled,
            "Calling fetchCurrencies() should not ask the cache to create new list of currencies"
        )
        
        XCTAssertTrue(
            remoteCurrenciesServiceSpy.fetchCurrenciesCalled,
            "Calling fetchCurrencies() should ask the remote for a list of currencies"
        )
        XCTAssertEqual(
            0,
            remoteCurrenciesServiceSpy.currenciesResponse.count,
            "fetchCurrencies() should ask the remote to return a empty list of currencies"
        )
    }
}

extension Date {

    /// Create a date from specified parameters
    ///
    /// - Parameters:
    ///   - year: The desired year
    ///   - month: The desired month
    ///   - day: The desired day
    /// - Returns: A `Date` object
    static func from(year: Int, month: Int, day: Int) -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return calendar.date(from: dateComponents) ?? nil
    }
}
