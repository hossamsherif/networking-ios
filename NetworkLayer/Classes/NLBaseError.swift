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
    associatedtype T: Mappable
    var code: Int? { get set }
    var message: String? { get  set }
    var error: T? { get set }
}

open class NLBaseError<T: Mappable>: NLBaseErrorProtocol {
    public var code: Int?
    public var message: String?
    public var error: T?
    
    // MARK:- JSON
    required public init?(map: Map) { }
    
    open func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
        error = Mapper<T>().map(JSONObject: map.JSON)
    }
}

open class NLBaseErrorEmptyData: Mappable {
    required public init?(map: Map) { }
    open func mapping(map: Map) { }
}
