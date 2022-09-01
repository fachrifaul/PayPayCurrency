//
//  ExchangeRatesInteractorTests.swift
//  PayPayCurrencyTests
//
//  Created by Fachri Febrian on 17/08/2022.
//


@testable import PayPayCurrency
import XCTest

class ExchangeRatesInteractorTests: XCTestCase
{
    // MARK: - Subject under test
    
    var sut: ExchangeRatesInteractor!
    
    // MARK: - Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        setupExchangeRatesInteractor()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupExchangeRatesInteractor()
    {
        sut = ExchangeRatesInteractor()
    }
    
    // MARK: - Test doubles
    
    class ExchangeRatesPresentationLogicSpy: ExchangeRatesPresentationLogic
    {
        
        // MARK: Method call expectations
        var presentFromCurrencyCalled = false
        var presentLatestConversionRateCalled = false
        
        
        // MARK: Spied methods
        
        func presentFromCurrency(response: ExchangeRates.PickCurrency.Response) {
            presentFromCurrencyCalled = true
        }
        
        func presentLatestConversionRate(response: ExchangeRates.LatestRate.Response) {
            presentLatestConversionRateCalled = true
        }
        
    }
    
    class ExchangeRatesWorkerSpy: ExchangeRatesWorker
    {
        // MARK: Method call expectations
        
        var fetchCurrenciesCalled = false
        
        // MARK: Spied methods
        override func fetchLatestConversionRate(completion: @escaping ([String: Double]) -> Void) {
            fetchCurrenciesCalled = true
            completion([
                "AED": 3.673045,
                "AFN": 88.673585,
                "ALL": 115.168424,
            ])
        }
    }
    
    // MARK: - Tests
    
    func testFetchCurrenciesShouldAskCountryCurrencyWorkerToFetchCurrenciesAndPresenterToFormatResult()
    {
        // Given
        let presentationLogicSpy = ExchangeRatesPresentationLogicSpy()
        sut.presenter = presentationLogicSpy
        let workerSpy = ExchangeRatesWorkerSpy()
        sut.worker = workerSpy
        
        // When
        let request = ExchangeRates.LatestRate.Request()
        sut.fetchLatestConversionRate(request: request)
        
        // Then
        XCTAssert(
            workerSpy.fetchCurrenciesCalled,
            "fetchLatestConversionRate() should ask ExchangeRatesWorker to fetch exchange rate"
        )
        XCTAssert(
            presentationLogicSpy.presentFromCurrencyCalled,
            "fetchLatestConversionRate() should ask presenter to display from currency"
        )
        XCTAssert(
            presentationLogicSpy.presentLatestConversionRateCalled,
            "fetchLatestConversionRate() should ask presenter to display result all currencies"
        )
    }
    
    
    func testConvertRateShouldAskExchangeRatesWorkerToFetchCurrenciesAndPresenterToFormatResult()
    {
        // Given
        let presentationLogicSpy = ExchangeRatesPresentationLogicSpy()
        sut.presenter = presentationLogicSpy
        let workerSpy = ExchangeRatesWorkerSpy()
        sut.worker = workerSpy
        
        // When
        let request = ExchangeRates.LatestRate.Request()
        sut.convertRate(request: request)
        
        // Then
        XCTAssert(
            presentationLogicSpy.presentFromCurrencyCalled,
            "fetchLatestConversionRate() should ask presenter to from currency result"
        )
        XCTAssert(
            presentationLogicSpy.presentLatestConversionRateCalled,
            "fetchLatestConversionRate() should ask presenter to currencies result"
        )
    }
    
}


