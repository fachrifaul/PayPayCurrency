//
//  LatestRateCacheDataSource.swift
//  PayPayCurrency
//
//  Created by Fachri Febrian on 16/08/2022.
//

import Foundation

class LatestRateCacheDataSource {
    
    private let key = "latest_rate_excahange"
    
    let userDefaults: UserDefaults
    
    init (userDefaults: UserDefaults = UserDefaults.standard){
        self.userDefaults = userDefaults
    }
    
    func createLatestConversionRate(rates: [String : Double]) {
        userDefaults.set(rates, forKey: key)
    }
    
    func fetchLatestConversionRate() -> [String : Double] {
        guard let rates = userDefaults.value(forKey: key) as? [String : Double]
        else {
            return [:]
        }
        return rates
    }
}
