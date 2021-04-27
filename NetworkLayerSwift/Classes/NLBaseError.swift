//
//  BaseError.swift
//  Network Layer
//
//  Created by Ahmed masoud on 7/17/20.
//  Copyright © 2020 Rubikal. All rights reserved.
//

import Foundation

public protocol NLBaseErrorProtocol: Decodable {
    associatedtype T: Decodable
    var code: Int? { get set }
    var message: String? { get  set }
    var error: T? { get set }
}

open class NLBaseError<T: Decodable>: NLBaseErrorProtocol {
    public var code: Int?
    public var message: String?
    public var error: T?
}

open class NLBaseErrorEmptyData: Decodable { }
