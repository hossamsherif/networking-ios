//
//  HelloModel.swift
//  NetworkLayer_Example
//
//  Created by Hossam Sherif on 11/3/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

struct HelloModel: Decodable {
    
    var hello: String?
    
    enum CodingKeys: String, CodingKey {
        case hello = "message"
    }
}
