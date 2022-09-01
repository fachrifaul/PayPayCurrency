//
//  ExchangeRatesPresenterTests.swift
//  PayPayCurrencyTests
//
//  Created by Fachri Febrian on 17/08/2022.
//

@testable import PayPayCurrency
import XCTest

class ExchangeRatesPresenterTests: XCTestCase
{
    // MARK: - Subject under test
    
    var sut: ExchangeRatesPresenter!
    
    // MARK: - Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        setupPresenter()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupPresenter()
    {
        sut = ExchangeRatesPresenter()
    }
    
    // MARK: - Test doubles
    
    class ExchangeRatesDisplayLogicSpy: ExchangeRatesDisplayLogic {
      
        // MARK: Method call expectations
        
        var displayFromCurrencyCalled = false
        var displayLatestConversionRateCalled = false
        
        // MARK: Argument expectations
        
        var viewModelPickCurrency: ExchangeRates.PickCurrency.ViewModel!
        var viewModelLatestRate: ExchangeRates.LatestRate.ViewModel!
        
        // MARK: Spied methods
        func displayFromCurrency(viewModel: ExchangeRates.PickCurrency.ViewModel) {
            displayFromCurrencyCalled = true
            viewModelPickCurrency = viewModel
        }
        
        func displayLatestConversionRate(viewModel: ExchangeRates.LatestRate.ViewModel) {
            displayLatestConversionRateCalled = true
            viewModelLatestRate = viewModel
        }
        
    }
    
    // MARK: - Tests
    
    func testPresentFromCurrencyShouldFormatPresentFromCurrencyForDisplay()
    {
        // Given
        let displayLogicSpy = ExchangeRatesDisplayLogicSpy()
        sut.viewController = displayLogicSpy
        
        // When
        let currency = Currency(currency: "ALL", country: "Albanian Lek")
        let response = ExchangeRates.PickCurrency.Response(currency: currency)
        sut.presentFromCurrency(response: response)
        
        // Then
        let displayedCurrency = displayLogicSpy.viewModelPickCurrency.currency
        XCTAssertEqual(
            displayedCurrency?.currency,
            "ALL",
            "Presenting picked currency should properly format currency"
        )
        XCTAssertEqual(
            displayedCurrency?.country,
            "Albanian Lek",
            "Presenting picked currency should properly format country currency"
        )
    }
    
    func testPresentFromCurrencyShouldAskViewControllerForDisplay()
    {
        // Given
        let displayLogicSpy = ExchangeRatesDisplayLogicSpy()
        sut.viewController = displayLogicSpy
        
        // When
        let currency = Currency(currency: "ALL", country: "Albanian Lek")
        let response = ExchangeRates.PickCurrency.Response(currency: currency)
        sut.presentFromCurrency(response: response)
        
        // Then
        XCTAssert(
            displayLogicSpy.displayFromCurrencyCalled,
            "Presenting picked currency should ask view controller to display them"
        )
    }
    
    
    func testPresentLatestConversionRateShouldFormatPresentLatestConversionRateForDisplay()
    {
        // Given
        let displayLogicSpy = ExchangeRatesDisplayLogicSpy()
        sut.viewController = displayLogicSpy
        
        // When
        let currency = Currency(currency: "ALL", country: "Albanian Lek")
        let rates = ["AFN": 88.673585]
        let response = ExchangeRates.LatestRate.Response(rates: rates, currency: currency)
        sut.presentLatestConversionRate(response: response)
        
        // Then
        let displayeRates = displayLogicSpy.viewModelLatestRate.rates
        for displayeRate in displayeRates {
            XCTAssertEqual(
                displayeRate.name,
                "AFN",
                "Presenting picked currency should properly format currency"
            )
            XCTAssertEqual(
                displayeRate.amount,
                88.673585,
                "Presenting picked currency should properly format country currency"
            )
        }
    }
    
    func testPresentLatestConversionRateShouldAskViewControllerForDisplay()
    {
        // Given
        let displayLogicSpy = ExchangeRatesDisplayLogicSpy()
        sut.viewController = displayLogicSpy
        
        // When
        let currency = Currency(currency: "ALL", country: "Albanian Lek")
        let rates = ["AFN": 88.673585]
        let response = ExchangeRates.LatestRate.Response(rates: rates, currency: currency)
        sut.presentLatestConversionRate(response: response)
        
        // Then
        XCTAssert(
            displayLogicSpy.displayLatestConversionRateCalled,
            "Presenting picked currency should ask view controller to display them"
        )
    }
}


