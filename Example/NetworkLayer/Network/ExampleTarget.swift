//
//  TestTarget.swift
//  NetworkLayer_Example
//
//  Created by Hossam Sherif on 11/3/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import NetworkLayerSwift

enum ExampleTarget: TargetType {
    
    case getMessage
    case getPlain
    
    var baseURL: URL {
        return URL(string: "https://run.mocky.io/v3")!
    }
    
    var path: String {
        switch self {
        case .getMessage:
            return "/5f22be32-9248-4bfe-badf-4cc158c469b5"
        case .getPlain:
            return "/4a8ef2ac-5f6e-493b-9080-53b29f098eb9"
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var method: Method {
        switch self {
        case .getPlain:
            return .get
        case .getMessage:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getPlain:
            return .requestPlain
        case .getMessage:
            return .requestParameters(parameters: ["Hello" : true], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
}


