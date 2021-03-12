//
//  File.swift
//  NetworkLayer
//
//  Created by Hossam Sherif on 11/3/20.
//

import Foundation
import Moya

/// TargetType representation
public typealias TargetType = Moya.TargetType
/// Task representation
public typealias Task = Moya.Task
/// Default Session manager
public typealias Session = Moya.Session
/// Represents an HTTP method.
public typealias Method = Moya.Method
/// Choice of parameter encoding.
public typealias ParameterEncoding = Moya.ParameterEncoding
public typealias JSONEncoding = Moya.JSONEncoding
public typealias URLEncoding = Moya.URLEncoding
/// Multipart form.
public typealias RequestMultipartFormData = Moya.MultipartFormData
/// Multipart form data encoding result.
public typealias DownloadDestination = Moya.DownloadDestination
/// Represents Request interceptor type that can modify/act on Request
public typealias RequestInterceptor = Moya.RequestInterceptor
/// Represeting Provider type in NetworkLayer
public typealias NLProvider = Moya.MoyaProvider


extension MoyaProvider {
    static func NLDefaultProvider() -> MoyaProvider<MultiTarget> {
        let loggerPlugin = NL.configuration.enableLogging ? [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))] : []
        return MoyaProvider<MultiTarget>(session: NL.session, plugins: loggerPlugin)
    }
}

extension Session {
    public static func NLDefaultSession() -> Session {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.timeoutIntervalForRequest = NLConstants.defaultTimeout
        configuration.timeoutIntervalForResource = NLConstants.defaultTimeout
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return Session(configuration: configuration)
    }
}

