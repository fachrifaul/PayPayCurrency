//
//  ExchangeRatesWorkerTests.swift
//  PayPayCurrencyTests
//
//  Created by Fachri Febrian on 17/08/2022.
//

@testable import PayPayCurrency
import XCTest

class ExchangeRatesWorkerTests: XCTestCase {
    
    // MARK: - Subject under test
    var limitBandwith: LimitBandwith!
    var userDefaults: UserDefaults!
    var sut: ExchangeRatesWorker!
    
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
        sut = ExchangeRatesWorker(
            cacheDataSource: LatestRateCacheDataSourceSpy(),
            apiDataSource: RemoteLatestRateApiDataSourceSpy()
        )
    }
    
    class LatestRateCacheDataSourceSpy: LatestRateCacheDataSource {
        // MARK: Method call expectations
        var createhRatesCalled = false
        var fetchRatesCalled = false
        
        var cacheRatesResponse: [String : Double] = [:]
        
        // MARK: Spied methods
        override func createLatestConversionRate(rates: [String : Double]) {
            createhRatesCalled = true
        }
        override func fetchLatestConversionRate() -> [String : Double] {
            fetchRatesCalled = true
            return cacheRatesResponse
        }
    }
    
    class RemoteLatestRateApiDataSourceSpy: LatestRateApiDataSource {
        // MARK: Method call expectations
        var fetchRatesCalled = false
        
        var ratesResponse: [String : Double] = [:]
        
        // MARK: Spied methods
        override func fetchLatestConversionRate(completion: @escaping ([String : Double]) -> Void) {
            fetchRatesCalled = true
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
                completion(self?.ratesResponse ?? [:])
            }
        }
    }
    
    
    // MARK: - Tests
    
    func testFetchCurrenciesShouldReturnListOfCurrencies_fromRemote() {
        // Given
        limitBandwith.saveTimeStamp(
            timestamp: Date().timeIntervalSince1970
        )
        let cacheLatestRateApiDataSourceSpy = sut.cacheDataSource as! LatestRateCacheDataSourceSpy
        
        let givenRemoteRatesResponse =  [
            "AED": 3.673045,
            "AFN": 88.673585,
            "IDR": 14773.140453,
        ]
        let remoteLatestRateApiDataSourceSpy = sut.apiDataSource as! RemoteLatestRateApiDataSourceSpy
        remoteLatestRateApiDataSourceSpy.ratesResponse = givenRemoteRatesResponse
        
        // When
        var fetchExchangeRates = [String: Double]()
        let expectation = expectation(description: "Wait for fetchLatestConversionRate() to return")
        sut.fetchLatestConversionRate { rates in
            fetchExchangeRates = rates
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        
        // Then
        XCTAssertTrue(
            cacheLatestRateApiDataSourceSpy.fetchRatesCalled,
            "Calling fetchLatestConversionRate() should ask the cache for a list of exchange rates"
        )
        XCTAssertEqual(
            0,
            cacheLatestRateApiDataSourceSpy.cacheRatesResponse.count,
            "fetchLatestConversionRate() should sk the cache to return a empty list of exchange rates"
        )
        XCTAssertTrue(
            cacheLatestRateApiDataSourceSpy.createhRatesCalled,
            "Calling fetchLatestConversionRate() should ask the cache to create new list of exchange rates"
        )
        
        XCTAssertTrue(
            remoteLatestRateApiDataSourceSpy.fetchRatesCalled,
            "Calling fetchLatestConversionRate() should ask the remote for a list of exchange rates"
        )
        XCTAssertEqual(
            fetchExchangeRates.count,
            givenRemoteRatesResponse.count,
            "fetchLatestConversionRate() should ask the remote to return a list of exchange rates"
        )
        XCTAssertEqual(
            fetchExchangeRates,
            givenRemoteRatesResponse,
            "fetchLatestConversionRate() should ask the remote to return a list of exchange rates"
        )
    }
    
    func testFetchCurrenciesShouldReturnListOfCurrencies_fromCache() {
        // Given
        limitBandwith.saveTimeStamp(
            timestamp: Date().timeIntervalSince1970
        )
        let givenCacheCurrenciesResponse =  [
            "AED": 3.673045,
            "AFN": 88.673585,
            "IDR": 14773.140453,
        ]
        let cacheLatestRateApiDataSourceSpy = sut.cacheDataSource as! LatestRateCacheDataSourceSpy
        cacheLatestRateApiDataSourceSpy.cacheRatesResponse = givenCacheCurrenciesResponse
        
        let remoteLatestRateApiDataSourceSpy = sut.apiDataSource as! RemoteLatestRateApiDataSourceSpy
        
        // When
        var fetchExchangeRates = [String: Double]()
        let expectation = expectation(description: "Wait for fetchLatestConversionRate() to return")
        sut.fetchLatestConversionRate { currencies in
            fetchExchangeRates = currencies
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10.0)
        
        // Then
        XCTAssertTrue(
            cacheLatestRateApiDataSourceSpy.fetchRatesCalled,
            "Calling fetchLatestConversionRate() should ask the cache for a list of currencies"
        )
        XCTAssertEqual(
            givenCacheCurrenciesResponse.count,
            fetchExchangeRates.count,
            "fetchLatestConversionRate() should ask the cache to return a list of currencies"
        )
        XCTAssertEqual(
            fetchExchangeRates,
            givenCacheCurrenciesResponse,
            "fetchLatestConversionRate() in cache should match list of currencies"
        )
        XCTAssertFalse(
            cacheLatestRateApiDataSourceSpy.createhRatesCalled,
            "Calling fetchLatestConversionRate() should not ask the cache to create new list of currencies"
        )
        
        XCTAssertTrue(
            remoteLatestRateApiDataSourceSpy.fetchRatesCalled,
            "Calling fetchLatestConversionRate() should ask the remote for a list of currencies"
        )
        XCTAssertEqual(
            0,
            remoteLatestRateApiDataSourceSpy.ratesResponse.count,
            "fetchLatestConversionRate() should ask the remote to return a empty list of currencies"
        )
    }
}
