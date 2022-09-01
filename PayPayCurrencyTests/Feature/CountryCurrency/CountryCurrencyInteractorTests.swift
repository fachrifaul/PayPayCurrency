//
//  CountryCurrencyInteractorTests.swift
//  PayPayCurrencyTests
//
//  Created by Fachri Febrian on 17/08/2022.
//

@testable import PayPayCurrency
import XCTest

class CountryCurrencyInteractorTests: XCTestCase
{
    // MARK: - Subject under test
    
    var sut: CountryCurrencyInteractor!
    
    // MARK: - Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        setupCountryCurrencyInteractor()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupCountryCurrencyInteractor()
    {
        sut = CountryCurrencyInteractor()
    }
    
    // MARK: - Test doubles
    
    class CountryCurrencyPresentationLogicSpy: CountryCurrencyPresentationLogic
    {
        
        // MARK: Method call expectations
        
        var presentCurrenciesCalled = false
        
        // MARK: Spied methods
        
        func presentCurrencies(response: CountryCurrency.Currencies.Response) {
            presentCurrenciesCalled = true
        }
    }
    
    class CountryCurrencyWorkerSpy: CountryCurrencyWorker
    {
        // MARK: Method call expectations
        
        var fetchCurrenciesCalled = false
        
        // MARK: Spied methods
        override func fetchCurrencies(completion: @escaping ([String : String]) -> Void) {
            fetchCurrenciesCalled = true
            completion([
                "AED": "United Arab Emirates Dirham",
                "AFN": "Afghan Afghani",
                "ALL": "Albanian Lek"
            ])
        }
    }
    
    // MARK: - Tests
    
    func testFetchCurrenciesShouldAskCountryCurrencyWorkerToFetchCurrenciesAndPresenterToFormatResult()
    {
        // Given
        let countryCurrencyPresentationLogicSpy = CountryCurrencyPresentationLogicSpy()
        sut.presenter = countryCurrencyPresentationLogicSpy
        let countryCurrencyWorkerSpy = CountryCurrencyWorkerSpy()
        sut.worker = countryCurrencyWorkerSpy
        
        // When
        let request = CountryCurrency.Currencies.Request()
        sut.fetchCurrencies(request: request)
        
        // Then
        XCTAssert(
            countryCurrencyWorkerSpy.fetchCurrenciesCalled,
            "fetchCurrencies() should ask  CountryCurrencyWorker to fetch currencies"
        )
        XCTAssert(
            countryCurrencyPresentationLogicSpy.presentCurrenciesCalled,
            "fetchCurrencies() should ask presenter to format currencies result"
        )
    }
    
}

