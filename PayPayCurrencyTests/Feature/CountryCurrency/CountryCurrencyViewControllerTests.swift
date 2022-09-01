//
//  CountryCurrencyViewControllerTests.swift
//  PayPayCurrencyTests
//
//  Created by Fachri Febrian on 17/08/2022.
//

@testable import PayPayCurrency
import XCTest

class CountryCurrencyViewControllerTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: CountryCurrencyViewController!
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
        sut = storyboard.instantiateViewController(withIdentifier: "CountryCurrencyViewController") as? CountryCurrencyViewController
    }
    
    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    // MARK: Test doubles
    
    class CountryCurrencyBusinessLogicSpy: CountryCurrencyBusinessLogic {
        var fetchCurrenciesCalled = false
        
        func fetchCurrencies(request: CountryCurrency.Currencies.Request) {
            fetchCurrenciesCalled = true
        }
    }
    
    
    class TableViewSpy: UITableView
    {
        // MARK: Method call expectations
        
        var reloadDataCalled = false
        
        // MARK: Spied methods
        
        override func reloadData()
        {
            reloadDataCalled = true
        }
    }
    
    class CountryCurrencyRouterSpy: CountryCurrencyRouter {
        // MARK: Method call expectations
        
        var popViewControllerCalled = false
        
        // MARK: Spied methods
        override func popViewController(segue: UIStoryboardSegue?) {
            popViewControllerCalled = true
        }
    }
    
    // MARK: Tests
    
    func testShouldDoFetchCurrenciesWhenViewIsLoaded() {
        // Given
        let spy = CountryCurrencyBusinessLogicSpy()
        sut.interactor = spy
        
        // When
        loadView()
        
        // Then
        XCTAssertTrue(spy.fetchCurrenciesCalled, "viewDidLoad() should ask the interactor to fetchCurrencies")
    }
    
    func testShouldDisplayCurrencies() {
        // Given
        loadView()
        
        let tableViewSpy = TableViewSpy()
        sut.currencyTableView = tableViewSpy
        
        let currencies = [
            Currency(currency: "ALL", country: "Albanian Lek"),
        ]
        let viewModel = CountryCurrency.Currencies.ViewModel(currencies: currencies)
        
        // When
        loadView()
        sut.displayCurrencies(viewModel: viewModel)
        
        // Then
        XCTAssert(tableViewSpy.reloadDataCalled, "Displaying fetched currencies should reload the table view")
    }
    
    
    
    func testNumberOfSectionsInTableViewShouldAlwaysBeOne() {
        // Given
        loadView()
        
        let tableView = sut.currencyTableView
        let currencies = [
            Currency(currency: "ALL", country: "Albanian Lek"),
        ]
        sut.currencies = currencies
        
        // When
        let numberOfSections = sut.numberOfSections(in: tableView!)
        
        // Then
        XCTAssertEqual(numberOfSections, 1, "The number of table view sections should always be 1")
    }
    
    
    func testNumberOfRowsInAnySectionShouldEqaulNumberOfOrdersToDisplay()
    {
        // Given
        loadView()
        
        let tableView = sut.currencyTableView
        let currencies = [
            Currency(currency: "ALL", country: "Albanian Lek"),
            Currency(currency: "USD", country: "United States Dollar")
        ]
        sut.currencies = currencies
        
        // When
        let numberOfRows = sut.tableView(tableView!, numberOfRowsInSection: 0)
        
        // Then
        XCTAssertEqual(numberOfRows, currencies.count, "The number of table view rows should equal the number of orders to display")
    }
    
    
    
    func testShouldConfigureTableViewCellToDisplayCurrencies()
    {
        // Given
        loadView()
        
        let tableView = sut.currencyTableView
        let currencies = [
            Currency(currency: "ALL", country: "Albanian Lek"),
        ]
        sut.currencies = currencies
        
        // When
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView(tableView!, cellForRowAt: indexPath)
        
        // Then
        XCTAssertEqual(
            cell.textLabel?.text,
            "ALL",
            "A properly configured table view cell should display the currency"
        )
        XCTAssertEqual(
            cell.detailTextLabel?.text,
            "Albanian Lek",
            "A properly configured table view cell should display the order total"
        )
        
    }
    
    
    func testNumberOfRowsInAnySectionShouldEqaulNumberOfOrdersToDisplay2()
    {
        // Given
        loadView()
        
        let tableView = sut.currencyTableView
        let currencies = [
            Currency(currency: "ALL", country: "Albanian Lek"),
            Currency(currency: "USD", country: "United States Dollar")
        ]
        sut.currencies = currencies
        
        let routerSpy = CountryCurrencyRouterSpy()
        sut.router = routerSpy
        
        // When
        let indexPath = IndexPath(row: 0, section: 0)
        sut.tableView(tableView!, didSelectRowAt: indexPath)
        
        // Then
        XCTAssertEqual(
            sut?.currency?.currency,
            "ALL",
            "A properly pick currency"
        )
        
        XCTAssertEqual(
            sut?.currency?.country,
            "Albanian Lek",
            "A properly pick countru currency"
        )
        
        XCTAssert(
            routerSpy.popViewControllerCalled,
            "Route to pop view controller"
        )
    }
    
    
}
