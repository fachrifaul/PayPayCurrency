//
//  ExchangeRatesViewControllerTests.swift
//  PayPayCurrencyTests
//
//  Created by Fachri Febrian on 18/08/2022.
//

@testable import PayPayCurrency
import XCTest

class ExchangeRatesViewControllerTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: ExchangeRatesViewController!
    var window: UIWindow!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupViewController()
    }
    
    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupViewController() {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        print(storyboard)
        sut = storyboard.instantiateViewController(withIdentifier: "ExchangeRatesViewController") as? ExchangeRatesViewController
    }
    
    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    // MARK: Test doubles
    
    class ExchangeRatesBusinessLogicSpy: ExchangeRatesBusinessLogic {
        var fetchLatestConversionRateCalled = false
        var convertRateCalled = false
        
        func fetchLatestConversionRate(request: ExchangeRates.LatestRate.Request) {
            fetchLatestConversionRateCalled = true
        }
        
        func convertRate(request: ExchangeRates.LatestRate.Request) {
            convertRateCalled = true
        }
    }
    
    
    class UICollectionViewSpy: UICollectionView
    {
        // MARK: Method call expectations
        
        var reloadDataCalled = false
        
        // MARK: Spied methods
        
        override func reloadData()
        {
            reloadDataCalled = true
        }
    }
    
    class ExchangeRatesRouterSpy: ExchangeRatesRouter {
        // MARK: Method call expectations
        
        var routeToCountryCurrenciesCalled = false
        
        // MARK: Spied methods
        override func routeToCountryCurrencies(segue: UIStoryboardSegue?) {
            routeToCountryCurrenciesCalled = true
        }
    }
    
    // MARK: Tests
    
    func testShouldDoFetchCurrenciesWhenViewIsLoaded() {
        // Given
        let spy = ExchangeRatesBusinessLogicSpy()
        sut.interactor = spy
        
        // When
        loadView()
        
        // Then
        XCTAssertTrue(spy.fetchLatestConversionRateCalled, "viewDidLoad() should ask the interactor to fetchCurrencies")
    }
    
    func testShouldDisplayLatestConversionRate() {
        // Given
        loadView()
        
        let collectionViewSpy = UICollectionViewSpy(
            frame: CGRect.zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        sut.currencyCollectionView = collectionViewSpy
        
        let rates = [
            ExchangeRates.LatestRate.ViewModel.DisplayedRate(name: "USD", amount: 124.45)
        ]
        let currency = Currency(currency: "ALL", country: "Albanian Lek")
        let viewModel = ExchangeRates.LatestRate.ViewModel(rates: rates, currency: currency)
        
        // When
        loadView()
        sut.displayLatestConversionRate(viewModel: viewModel)
        
        // Then
        XCTAssert(collectionViewSpy.reloadDataCalled, "Displaying fetched latest exchange rates should reload the collectionview view")
    }
    
    func testNumberOfItemsInAnySectionShouldEqualNumberOfOrdersToDisplay() {
        // Given
        loadView()
        
        let collectionView = sut.currencyCollectionView
        let rates = [
            ExchangeRates.LatestRate.ViewModel.DisplayedRate(name: "USD", amount: 124.45),
            ExchangeRates.LatestRate.ViewModel.DisplayedRate(name: "ALL", amount: 124.45),
        ]
        sut.rates = rates
        
        // When
        let numberOfItems = sut.collectionView(collectionView!, numberOfItemsInSection: 0)
        
        // Then
        XCTAssertEqual(numberOfItems, rates.count, "The number of collection view items should equal the number of rates to display")
    }
    
    
    
    func testShouldConfigureCollectionViewCellToDisplayCurrencies()
    {
        // Given
        loadView()
        
        let collectionView = sut.currencyCollectionView
        let rates = [
            ExchangeRates.LatestRate.ViewModel.DisplayedRate(name: "USD", amount: 124.45),
            ExchangeRates.LatestRate.ViewModel.DisplayedRate(name: "ALL", amount: 124.45),
        ]
        sut.rates = rates
        
        // When
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.collectionView(collectionView!, cellForItemAt: indexPath) as? CurrencyCell
        
        // Then
        XCTAssertEqual(
            cell?.currencyNameLbl.text,
            "USD",
            "A properly configured table view cell should display the currency"
        )
        XCTAssertEqual(
            cell?.currencyAmountLbl.text,
            "124.45",
            "A properly configured table view cell should display the order total"
        )
        
    }
    
    
}
