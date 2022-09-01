//
//  main.swift
//  PayPayCurrency
//
//  Created by Fachri Febrian on 19/08/2022.
//

import UIKit

private func delegateClassName() -> String? {
    return NSClassFromString("XCTestCase") == nil ? NSStringFromClass(AppDelegate.self) : nil
}


UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, delegateClassName())
