//
//  BaseResponse.swift
//  Network Layer
//
//  Created by Ahmed masoud on 8/14/20.
//  Copyright © 2020 Rubikal. All rights reserved.
//

import Foundation
import ObjectMapper

public class NLBaseResponse<T: Mappable>: Mappable {
    
    public var code: Int?
    public var data: T?
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        code <- map["status_code"]
        data <- map["data"]
    }
}

public class NLBaseArrayResponse<T: Mappable>: Mappable {
    
    public var code: Int?
    public var data: [T]?
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        code <- map["status_code"]
        data <- map["data"]
    }
}


/// BaseEmptyResponse is used with NL.sendRequest which return only success and failure of the call without accually use this Mappable
/// - see also: BaseAPI.SendRequest
public class NLBaseEmptyResponse: Mappable {
    required public init?(map: Map) {}
    public func mapping(map: Map) {}
}

