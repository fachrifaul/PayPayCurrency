//
//  MockURLProtocol.swift
//  PayPayCurrencyTests
//
//  Created by Fachri Febrian on 17/08/2022.
//

import Foundation

public class MockURLProtocol: URLProtocol {
    public static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
    
    override public class func canInit(with _: URLRequest) -> Bool { true }
    
    override public class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    
    override public func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
          fatalError("Handler is unavailable.")
        }
        
        let (response, data): (HTTPURLResponse, Data?)
        do {
            (response, data) = try handler(request)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        
        if let data = data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override public func stopLoading() { }
}


//enum APIResponseError : Error, Equatable {
//    case jsonParse
//    case network
//    case messageError(String)
//    case requestIdInvalid
//}
