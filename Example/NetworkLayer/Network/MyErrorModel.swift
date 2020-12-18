//
//  MyErrorModel.swift
//  NetworkLayer_Example
//
//  Created by Hossam Sherif on 12/17/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import NetworkLayer
import ObjectMapper

public class MyErrorModel: Mappable {
    var custom:String = ""
    
    public required init?(map: Map) { }
    
    public func mapping(map: Map) {
        custom <- map["custom"]
    }
}

extension NSError {
    public var errorObject: MyErrorModel? {
        return getErrorObject(MyErrorModel.self)
    }
}



