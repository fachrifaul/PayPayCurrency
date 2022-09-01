//
//  NetworkConstant.swift
//  PayPayCurrency
//
//  Created by Fachri Febrian on 15/08/2022.
//

import Foundation

struct NetworkConstant {
    static let appId = "e4007f337b8a4effa3ddd0f7607f72f6"
    static let baseUrl = "https://openexchangerates.org/api/"
    static let currenciesEndpoint = baseUrl + "currencies.json"
    static let latestRateEndpoint = baseUrl + "latest.json"
}

