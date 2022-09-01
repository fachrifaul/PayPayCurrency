//
//  CurrenciesCacheDataSource.swift
//  PayPayCurrency
//
//  Created by Fachri Febrian on 16/08/2022.
//

import Foundation

class CurrenciesCacheDataSource {
    private let key = "all_currencies"
    
    let userDefaults: UserDefaults
    
    init (userDefaults: UserDefaults = UserDefaults.standard){
        self.userDefaults = userDefaults
    }
    
    func createCurrencies(currencies: [String : String]) {
        userDefaults.set(currencies, forKey: key)
    }
    func fetchCurrencies() -> [String : String] {
        guard let currencies = userDefaults.value(forKey: key) as? [String : String]
        else {
            return [:]
        }
        return currencies
    }
}
