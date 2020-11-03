//
//  NetworkLayer.swift
//  NetworkLayer
//
//  Created by Hossam Sherif on 11/3/20.
//

import Foundation
import Moya
import ObjectMapper
import DataCache

public struct NLConfiguration {
    
    /// Set to enable logging
    public var enableLogging: Bool
    
    /// used to retrive failed request from userInfo associated with  apiConnectionFailure Notification
    public var apiConnectionFailureUserInfoKey:String

    /// providing a custom apiConnectionFailure Notification.Name
    public var apiConnectionFailure: Notification.Name
    
    public init(enableLogging:Bool = false,
                apiConnectionFailureUserInfoKey:String = "NLApiConnectionFailureUserInfoKey",
                apiConnectionFailure:Notification.Name = Notification.Name("NLApiConnectionFailure")) {
        self.enableLogging = enableLogging
        self.apiConnectionFailureUserInfoKey = apiConnectionFailureUserInfoKey
        self.apiConnectionFailure = apiConnectionFailure
    }
}

public struct NLReachabilbityConfiguration {
    
    /// used to retrive connection changes from userInfo associated with  reachabilityDidChangeConnection Notification
    public var didChangeConnectionUserInfoKey:String
    
    /// providing a custom reachabilityDidChangeConnection Notification.Name
    public var didChangeConnection:Notification.Name
    
    public init(didChangeConnectionUserInfoKey:String = "reachabilityDidChangeConnectionUserInfoKey",
                didChangeConnection:Notification.Name = Notification.Name("reachabilityDidChangeConnection")) {
        self.didChangeConnectionUserInfoKey = didChangeConnectionUserInfoKey
        self.didChangeConnection = didChangeConnection
    }
}

extension  Notification.Name {
    public static var NLDidChangeConnection:Notification.Name {
        return NL.configuration.apiConnectionFailure
    }
    public static var NLApiConnectionFailure:Notification.Name {
        return NL.reachabilityConfiguration.didChangeConnection
    }
}

public typealias ReauthenticateBlockType = ((()->())->())

/// Shorthand for convenience instead of NetworkLayerWrapper.shared
public let NL = NetworkLayerProvider.default

public class NetworkLayerProvider {
    
    /// NetworkLayerWrapper configuration
    open var configuration:NLConfiguration
    
    /// Reachability configuration
    open var reachabilityConfiguration:NLReachabilbityConfiguration
    
    /// ReauthenticateBlock called with associated block when the server reply with 401 unauthorized
    /// Typically call retryBlock when successully authenticated
    open var reauthenticateBlock: ReauthenticateBlockType?
    
    /// defaultSession is ultimatly an Almorfire.Session
    /// Note:
    /// - if needed it should be set before any usage of the NetworkLayerWrapper
    /// - The timeoutInterval should be set before the usage of the NetworkLayerWrapper
    open var session: Session
    
    /// Main provider used by NetworkLayer
    open lazy var baseAPI: NLBaseAPI = NLBaseAPI.default
    
    /// Default instance with default configuration
    public static let `default` = NetworkLayerProvider()
    
    open var cacheManager: DataCache
    
    /// Init for NetworkLayerWrapper
    /// - Parameters:
    ///   - session: Session used by NetworkLayerWrapper
    ///   - configuration: NLConfiguration struct for settings NetworkLayerWrapper configuration
    ///   - reachabilityConfig: ReachabilityConfiguration struct for setting ReachibilityManager configuration
    ///   - reauthenticateBlock: ReauthenticateBlockType used when 401 unauthorized reponsed from server to retry last failed request
    init(configuration:NLConfiguration = NLConfiguration(),
         reachabilityConfiguration:NLReachabilbityConfiguration = NLReachabilbityConfiguration(),
         reauthenticateBlock:ReauthenticateBlockType? = nil,
         cacheManager:DataCache = DataCache(name: String(reflecting: NetworkLayerProvider.self)),
         session:Session = Session.NLDefaultSession()) {
        self.configuration = configuration
        self.reachabilityConfiguration = reachabilityConfiguration
        self.cacheManager = cacheManager
        self.session = session
        ReachabilityManager.shared.startMonitoring()
    }
    
    /// Init for NetworkLayerWrapper
    /// - Parameters:
    ///   - baseAPI: NLBaseAPI provider
    ///   - configuration: NLConfiguration struct for settings NetworkLayerWrapper configuration
    ///   - reachabilityConfig: ReachabilityConfiguration struct for setting ReachibilityManager configuration
    ///   - reauthenticateBlock: ReauthenticateBlockType used when 401 unauthorized reponsed from server to retry last failed request
    convenience init(configuration:NLConfiguration = NLConfiguration(),
                     reachabilityConfiguration:NLReachabilbityConfiguration = NLReachabilbityConfiguration(),
                     reauthenticateBlock:ReauthenticateBlockType? = nil,
                     cacheManager:DataCache = DataCache(name: String(reflecting: NetworkLayerProvider.self)),
                     baseAPI:NLBaseAPI) {
        self.init()
        self.baseAPI = baseAPI
    }
    
    
    //MARK: Methods
    /// Send plain request with expected empty response
    /// - Parameters:
    ///   - target: TaregeType of current request
    ///   - shouldRetryOn401: if should attempt to retry on unauthorize response 401 by call reauthenticate from NLWrapper
    ///   - completion: completion block with results
    /// - Returns: CancellableRequest or nil if no network connection
    @discardableResult
    public func sendRequest<T: TargetType>(target: T, shouldRetryOn401: Bool = true,completion:@escaping NLCompletionVoid) -> CancellableRequest? {
        return NLBaseAPI.default.sendRequest(target: target, shouldRetryOn401: shouldRetryOn401,completion: completion)
    }
    
    /// Send request with expected mappable object returned
    /// - Parameters:
    ///   - target: TaregeType of current request
    ///   - shouldRetryOn401: if should attempt to retry on unauthorize response 401 by call reauthenticate from NLWrapper
    ///   - responseClass: Mappable response class
    ///   - progress: progress block (usually used with uploads and download)
    ///   - completion: completion block with results
    /// - Returns: CancellableRequest or nil if no network connection
    @discardableResult
    public func fetchData<M: Mappable, T:TargetType>(target: T,
                                                     responseClass: M.Type,
                                                     shouldRetryOn401: Bool = true,
                                                     progress:((Double)-> Void)? = nil,
                                                     cachedResponseKey: String? = nil,
                                                     completion:@escaping NLCompletionMappable<M>) -> CancellableRequest? {
        return NLBaseAPI.default.fetchData(target: target,
                                           shouldRetryOn401: shouldRetryOn401,
                                           responseClass: responseClass,
                                           progress: progress,
                                           cachedResponseKey: cachedResponseKey,
                                           completion: completion)
    }
    

}
