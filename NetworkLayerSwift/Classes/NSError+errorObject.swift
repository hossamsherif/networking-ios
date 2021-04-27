//
//  NSError+errorObject.swift
//  NetworkLayer
//
//  Created by Hossam Sherif on 12/17/20.
//

import Foundation

extension NSError {
    public func getErrorObject<E: Decodable>(_ type: E.Type) -> E? {
        guard let data = try? JSONSerialization.data(withJSONObject: userInfo, options: []) else { return nil }
        return try? JSONDecoder().decode(E.self, from: data)
    }
}
