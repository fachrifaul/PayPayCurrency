//
//  Service.swift
//  PayPayCurrency
//
//  Created by Fachri Febrian on 15/08/2022.
//

import Foundation
import SystemConfiguration

public class Service {
    public static let shared = Service()
    
    let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
      self.urlSession = urlSession
    }
    
    func request<T: Codable> (
        endPoint: String?,
        expecting: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        
        guard let url = URL(string: "\(endPoint ?? "")?app_id=\(NetworkConstant.appId)")
        else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task: URLSessionDataTask = urlSession.dataTask(with: request as URLRequest) { data, response, error in
            
            guard let data = data else {
                if let error = error {
                    completion(.failure(error)) 
                } else {
                    completion(.failure(NetworkError.invalidData))
                }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            }
            catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    static func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}
