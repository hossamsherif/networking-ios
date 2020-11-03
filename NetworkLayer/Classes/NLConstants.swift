//
//  BaseErrorMessage.swift
//  NetworkLayer
//
//  Created by Ahmed masoud on 11/3/20.
//

import Foundation

public struct NLConstants {
    public static let defaultTimeout:TimeInterval = 30.0
}

struct NLBaseErrorMessage {
    static let genericErrorMessage = "Couldn't submit your request. Please try again later."
    static let noStatusError = "No status code something went wrong"
    static let noResponseError = "No response"
    static let decodeError = "failed to decode object"
}
