//
//  CurrenciesApiDataSource.swift
//  PayPayCurrency
//
//  Created by Fachri Febrian on 15/08/2022.
//

import Foundation

class CurrenciesApiDataSource {
    
    let service: Service
    
    init (service: Service = Service.shared){
        self.service = service
    }
    
    func fetchCurrencies(completion: @escaping ([String : String]) -> Void) {
        service.request(
            endPoint: NetworkConstant.currenciesEndpoint,
            expecting: [String : String].self
        ) { result in
            switch result {
            case .success(let countries):
                completion(countries)
            case .failure(_):
                completion([:])
            }
        }
    }
    
}
