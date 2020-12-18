//
//  NSError+errorObject.swift
//  NetworkLayer
//
//  Created by Hossam Sherif on 12/17/20.
//

import Foundation
import ObjectMapper

extension NSError {
    public func getErrorObject<E: Mappable>(_ type: E.Type) -> E? {
        return E(JSON: userInfo)
    }
}
