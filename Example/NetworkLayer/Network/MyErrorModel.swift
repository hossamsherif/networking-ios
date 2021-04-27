//
//  MyErrorModel.swift
//  NetworkLayer_Example
//
//  Created by Hossam Sherif on 12/17/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import NetworkLayerSwift

public struct MyErrorModel: Decodable {
    let custom:String
}

extension NSError {
    public var errorObject: MyErrorModel? {
        return getErrorObject(MyErrorModel.self)
    }
}



