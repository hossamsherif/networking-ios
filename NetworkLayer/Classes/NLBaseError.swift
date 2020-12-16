//
//  BaseError.swift
//  Network Layer
//
//  Created by Ahmed masoud on 7/17/20.
//  Copyright © 2020 Rubikal. All rights reserved.
//

import Foundation
import ObjectMapper

public class NLBaseError: NLBaseErrorProtocol {
    public var code: Int?
    public var errors: [String]?
    
    // MARK:- JSON
    required public init?(map: Map) {
        self.mapping(map: map)
    }
    
    
    public func mapping(map: Map) {
        code <- map["code"]
        errors <- map["errors"]
    }
}

public protocol NLBaseErrorProtocol: Mappable {
    var code: Int? { get set }
    var errors: [String]? { get  set }
}
