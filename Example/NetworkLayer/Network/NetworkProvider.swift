//
//  NetworkProvider.swift
//  NetworkLayer_Example
//
//  Created by Hossam Sherif on 11/3/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import NetworkLayer

typealias HelloModelResult = (_ result: Result<HelloModel?, NSError>,_ cached: Bool) -> Void

protocol NetworkProviderProtocol {
    @discardableResult
    func getPlain(completion: @escaping (Result<Void, NSError>) -> Void) -> CancellableRequest?
    @discardableResult
    func getHello(completion: @escaping HelloModelResult) -> CancellableRequest?
}

class NetworkProvider: NetworkProviderProtocol {
    @discardableResult
    func getPlain(completion: @escaping (Result<Void, NSError>) -> Void) -> CancellableRequest? {
        return NL.sendRequest(target: ExampleTarget.getPlain, completion: completion)
    }
    
    @discardableResult
    func getHello(completion: @escaping HelloModelResult) -> CancellableRequest? {
        return NL.fetchData(target: ExampleTarget.getMessage, responseClass: NLBaseResponse<HelloModel>.self, cachedResponseKey: ExampleTarget.getMessage.path) { (result, cached) in
            switch result {
            case .success(let response):
                completion(.success(response?.data), cached)
            case .failure(let error):
                completion(.failure(error), cached)
            }
        }
    }
}



