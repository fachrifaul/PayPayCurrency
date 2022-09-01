//
//  LimitBandwith.swift
//  PayPayCurrency
//
//  Created by Fachri Febrian on 18/08/2022.
//

import Foundation

class LimitBandwith {
    public static let shared = LimitBandwith()
    
    let userDefaults: UserDefaults
    
    let key = "limit_bandwith_usage"
    let requestTimeInterval = 60.0 * 30.0 // 30 minutes
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    func saveTimeStamp(timestamp: Double) {
        userDefaults.set(timestamp, forKey: key)
    }
    
    func getTimeStamp() -> Double? {
        return userDefaults.value(forKey: key) as? Double
    }
    
    func isCalledInLast30Min() -> Bool {
        guard let lastTimeStamp = getTimeStamp() else { return false }
        let now = Date().timeIntervalSince1970
        let time = now - lastTimeStamp
        print("now \(now)")
        print("lastTimeStamp \(lastTimeStamp)")
        print("time \(time) =  \(now) - \(lastTimeStamp)")
        print("requestTimeInterval \(requestTimeInterval)")
        print("isCalledInLast30Min \(time < requestTimeInterval)")
        if time < requestTimeInterval {
            return true
        } else {
            return false
        }
    }
}
