//
//  ViewController+Alert.swift
//  PayPayCurrency
//
//  Created by Fachri Febrian on 18/08/2022.
//

import UIKit

extension UIViewController {
    func displayAlertNoInternet() {
        let alert = UIAlertController(
            title: "Error",
            message: "No internet connection. Please try again later.",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil
        )
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
