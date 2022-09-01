//
//  LatestRateApiDataSource.swift
//  PayPayCurrency
//
//  Created by Fachri Febrian on 15/08/2022.
//

import Foundation

class LatestRateApiDataSource {
    let service: Service
    
    init (service: Service = Service.shared){
        self.service = service
    }
    
    func fetchLatestConversionRate(completion: @escaping ([String: Double]) -> Void) {
        service.request(
            endPoint: NetworkConstant.latestRateEndpoint,
            expecting: ConversionRate.self
        ) {  result in
            switch result {
            case .success(let conversionRate):
                if let timestamp = conversionRate.timestamp {
                    LimitBandwith.shared.saveTimeStamp(timestamp: timestamp)
                }
                
                if let rates = conversionRate.rates {
                    completion(rates)
                } else {
                    completion([:])
                }
            case .failure(_):
                completion([:])
            }
        }
    }
    
}
