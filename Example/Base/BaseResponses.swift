//
//  BaseResponse.swift
//  Network Layer
//
//  Created by Ahmed masoud on 8/14/20.
//  Copyright © 2020 Ahmed Masoud. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseResponse<T: Mappable>: Mappable {
    
    var code: Int?
    var data: T?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        code <- map["status_code"]
        data <- map["data"]
    }
}

class BaseArrayResponse<T: Mappable>: Mappable {
    
    var code: Int?
    var data: [T]?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        code <- map["status_code"]
        data <- map["data"]
    }
}
