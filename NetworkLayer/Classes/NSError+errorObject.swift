//
//  NSError+errorObject.swift
//  NetworkLayer
//
//  Created by Hossam Sherif on 12/17/20.
//

import Foundation

extension NSError {
    public func getErrorObject<E: NLBaseErrorProtocol>(_ type: E.Type) -> E? {
        return E(JSON: userInfo)
    }
}
