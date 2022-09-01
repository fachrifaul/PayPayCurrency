//
//  CurrenciesApiDataSourceTests.swift
//  PayPayCurrencyTests
//
//  Created by Fachri Febrian on 17/08/2022.
//

@testable import PayPayCurrency
import XCTest

class CurrenciesApiDataSourceTests: XCTestCase {
    
    // MARK: - Subject under test
    var sut: CurrenciesApiDataSource!
    var expectation: XCTestExpectation!
    let apiURL = URL(string: "https://openexchangerates.org/api/currencies.json?app_id=\(NetworkConstant.appId)")!
    
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
        
        sut = CurrenciesApiDataSource(service: service)
        expectation = expectation(description: "Expectation")
    }
    
    func resetCacheCurrencies() {
        sut = nil
    }
    
    
    // MARK: - Test Cases
    
    func testFetchCurrenciesShouldReturnListCurrencies() {
        // Given
        let jsonString = """
                         {
                             "AED": "United Arab Emirates Dirham",
                             "AFN": "Afghan Afghani",
                             "ALL": "Albanian Lek",
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
        sut.fetchCurrencies { currencies in
            
            // Then
            XCTAssertEqual(
                currencies,
                [ "AED": "United Arab Emirates Dirham",
                  "AFN": "Afghan Afghani",
                  "ALL": "Albanian Lek"],
                "fetchCurrencies() should return list rates"
            )
            XCTAssertEqual(currencies.count, 3, "fetchCurrencies() count equals three")
            
            self.expectation.fulfill()

        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    
    func testFetchCurrenciesShouldReturnEmptyCurrencies_Error() {
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
        sut.fetchCurrencies { currencies in
            
            // Then
            XCTAssertEqual(currencies, [:], "fetchCurrencies() should return empty currencies")
            XCTAssertEqual(currencies.count, 0, "fetchCurrencies() count equals zero")
            
            self.expectation.fulfill()

        }
        wait(for: [expectation], timeout: 5.0)
    }
}

