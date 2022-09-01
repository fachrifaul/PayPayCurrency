//
//  ConversionRate.swift
//  PayPayCurrency
//
//  Created by Fachri Febrian on 15/08/2022.
//

import Foundation

struct ConversionRate: Codable {
    let disclaimer: String?
    let license: String?
    let timestamp: Double?
    let base: String?
    let rates: [String: Double]?
}
