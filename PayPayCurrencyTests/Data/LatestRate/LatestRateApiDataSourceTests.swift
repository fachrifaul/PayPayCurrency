//
//  LatestRateApiDataSourceTests.swift
//  PayPayCurrencyTests
//
//  Created by Fachri Febrian on 17/08/2022.
//

@testable import PayPayCurrency
import XCTest

class LatestRateApiDataSourceTests: XCTestCase {
    
    // MARK: - Subject under test
    var sut: LatestRateApiDataSource!
    var expectation: XCTestExpectation!
    let apiURL = URL(string: "https://openexchangerates.org/api/latest.json?app_id=\(NetworkConstant.appId)")!
    
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
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        let service = Service(urlSession: urlSession)
        
        sut = LatestRateApiDataSource(service: service)
        expectation = expectation(description: "Expectation")
    }
    
    func resetCacheCurrencies() {
        sut = nil
    }
    
    
    // MARK: - Test Cases
    
    func testFetchLatestRatesShouldReturnListRates() {
        // Given
        let jsonString = """
                         {
                             "disclaimer": "Usage subject to terms: https://openexchangerates.org/terms",
                             "license": "https://openexchangerates.org/license",
                             "timestamp": 1660737600,
                             "base": "USD",
                             "rates": {
                                 "AED": 3.673045,
                                 "AFN": 88.673585,
                                 "ALL": 115.168424,
                             }
                         }
                         """
        let data = jsonString.data(using: .utf8)
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url, url == self.apiURL else {
                throw NetworkError.invalidUrl
            }
            
            let response = HTTPURLResponse(
                url: self.apiURL,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, data)
        }
        
        // When
        sut.fetchLatestConversionRate { rates in
            
            // Then
            XCTAssertEqual(
                rates,
                ["AED": 3.673045,
                 "AFN": 88.673585,
                 "ALL": 115.168424,],
                "fetchLatestConversionRate() should return list rates"
            )
            XCTAssertEqual(rates.count, 3, "fetchLatestConversionRate() count equals three")
            
            self.expectation.fulfill()

        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    
    func testFetchLatestRatesShouldReturnEmptyRates_Error() {
        // Given
        let jsonString = """
                         {
                             "error": true,
                             "status": 401,
                             "message": "invalid_app_id",
                             "description": "Invalid App ID provided. Please sign up at https://openexchangerates.org/signup, or contact support@openexchangerates.org."
                         }
                         """
        let data = jsonString.data(using: .utf8)
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url, url == self.apiURL else {
                throw NetworkError.invalidUrl
            }
            
            let response = HTTPURLResponse(
                url: self.apiURL,
                statusCode: 401,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, data)
        }
        
        // When
        sut.fetchLatestConversionRate { rates in
            
            // Then
            XCTAssertEqual(rates, [:], "fetchLatestConversionRate() should return empty rates")
            XCTAssertEqual(rates.count, 0, "fetchLatestConversionRate() count equals zero")
            
            self.expectation.fulfill()

        }
        wait(for: [expectation], timeout: 5.0)
    }
}

