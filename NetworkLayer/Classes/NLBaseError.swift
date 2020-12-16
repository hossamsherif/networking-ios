//
//  BaseError.swift
//  Network Layer
//
//  Created by Ahmed masoud on 7/17/20.
//  Copyright © 2020 Rubikal. All rights reserved.
//

import Foundation
import ObjectMapper

public protocol NLBaseErrorProtocol: Mappable {
    var code: Int? { get set }
    var message: String? { get  set }
    var data: [String: Any]? { get  set }
    var status: String? { get  set }
}

open class NLBaseError: NLBaseErrorProtocol {
    public var code: Int?
    public var message: String?
    public var data: [String: Any]?
    public var status: String?
    
    // MARK:- JSON
    required public init?(map: Map) { }
    
    open func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
        data <- map["data"]
        status <- map["status"]
    }
}
