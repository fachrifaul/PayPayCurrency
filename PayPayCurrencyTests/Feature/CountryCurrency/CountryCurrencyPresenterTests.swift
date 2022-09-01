//
//  CountryCurrencyPresenterTests.swift
//  PayPayCurrencyTests
//
//  Created by Fachri Febrian on 17/08/2022.
//

@testable import PayPayCurrency
import XCTest

class CountryCurrencyPresenterTests: XCTestCase
{
    // MARK: - Subject under test
    
    var sut: CountryCurrencyPresenter!
    
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
        sut = CountryCurrencyPresenter()
    }
    
    // MARK: - Test doubles
    
    class CountryCurrencyDisplayLogicSpy: CountryCurrencyDisplayLogic {
        
        // MARK: Method call expectations
        
        var displayFetchedOrdersCalled = false
        
        // MARK: Argument expectations
        
        var viewModel: CountryCurrency.Currencies.ViewModel!
        
        // MARK: Spied methods
        
        func displayCurrencies(viewModel: CountryCurrency.Currencies.ViewModel) {
            displayFetchedOrdersCalled = true
            self.viewModel = viewModel
        }
    }
    
    // MARK: - Tests
    
    func testPresentCurrenciesShouldFormatPresentCurrenciesForDisplay()
    {
        // Given
        let displayLogicSpy = CountryCurrencyDisplayLogicSpy()
        sut.viewController = displayLogicSpy
        
        // When
        let currencies = [
            Currency(currency: "ALL", country: "Albanian Lek"),
        ]
        let response = CountryCurrency.Currencies.Response(currencies: currencies)
        sut.presentCurrencies(response: response)
        
        // Then
        let displayeCurrencies = displayLogicSpy.viewModel.currencies
        for displayedOrder in displayeCurrencies {
            XCTAssertEqual(
                displayedOrder.currency,
                "ALL",
                "Presenting fetched currencies should properly format currency"
            )
            XCTAssertEqual(
                displayedOrder.country,
                "Albanian Lek",
                "Presenting fetched currencies should properly format country currency"
            )
        }
    }
    
    func testPresentCurrenciesShouldAskViewControllerForDisplay ()
    {
        // Given
        let displayLogicSpy = CountryCurrencyDisplayLogicSpy()
        sut.viewController = displayLogicSpy
        
        // When
        let currencies = [
            Currency(currency: "ALL", country: "Albanian Lek"),
        ]
        let response = CountryCurrency.Currencies.Response(currencies: currencies)
        sut.presentCurrencies(response: response)
        
        // Then
        XCTAssert(
            displayLogicSpy.displayFetchedOrdersCalled,
            "Presenting fetched currencies should ask view controller to display them"
        )
    }
}

