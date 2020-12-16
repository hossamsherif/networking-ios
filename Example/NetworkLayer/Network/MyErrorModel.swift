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

public class MyErrorModel: NLBaseError {
    var custom:String = ""
    
    public required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        custom <- map["custom"]
    }
}

extension NSError {
    public var errorObject: MyErrorModel? {
        return getErrorObject(MyErrorModel.self)
    }
}



