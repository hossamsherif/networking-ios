//
//  HelloModel.swift
//  NetworkLayer_Example
//
//  Created by Hossam Sherif on 11/3/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import ObjectMapper

struct HelloModel: Mappable {
    var hello: String?
    init?(map: Map) { }
    mutating func mapping(map: Map) {
        hello <- map["message"]
    }
}
