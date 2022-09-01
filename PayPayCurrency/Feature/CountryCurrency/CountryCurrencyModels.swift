//
//  CountryCurrencyModels.swift
//  PayPayCurrency
//
//  Created by Fachri Febrian on 15/08/2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum CountryCurrency {
  // MARK: Use cases
  
  enum Currencies {

    struct Request {

    }

    struct Response {
        var currencies: [Currency] = []
    }
    
    struct ViewModel {
        var currencies: [Currency] = []
    }
  }
}
