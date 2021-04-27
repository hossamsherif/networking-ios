//
//  BaseResponse.swift
//  Network Layer
//
//  Created by Ahmed masoud on 8/14/20.
//  Copyright © 2020 Rubikal. All rights reserved.
//

import Foundation

public class NLBaseResponse<T: Decodable>: Decodable {
    public var code: Int?
    public var data: T?
    enum CodingKeys: String, CodingKey {
        case code = "status_code"
        case data
    }
}

public class NLBaseArrayResponse<T: Decodable>: Decodable {
    
    public var code: Int?
    public var data: [T]?
    
    enum CodingKeys: String, CodingKey {
        case code = "status_code"
        case data
    }
}


/// BaseEmptyResponse is used with NL.sendRequest which return only success and failure of the call without accually use this Mappable
/// - see also: BaseAPI.SendRequest
public class NLBaseEmptyResponse: Decodable { }

