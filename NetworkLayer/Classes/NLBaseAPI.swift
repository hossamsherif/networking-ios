//
//  NLBaseAPI.swift
//  Network Layer
//
//  Created by Hossam Sherif on 11/2/20.
//  Copyright © 2020 Rubikal. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper

// Completion block with void type used with `sendRequest`
public typealias NLCompletionVoid = (Result<Void, NSError>) -> Void
// Completion block with mappable object used with `fetchData`
public typealias NLCompletionMappable<M: Mappable> = (Result<M?, NSError>, Bool) -> Void
// Progress block
public typealias NLProgressBlock = ((Double)-> Void)


/// BaseAPI provider for NetworkLayerProvider
/// Built up on MoyaProvider<MultiTarget> provider
/// Providers:
/// - sending plain request via `sendRequest` which only success and failure
/// - fetching data request via `fetchData` which return success with mappable object result or failure with error
/// Features:
/// - Caching with by providing cachedResponseKey - only available for `fetchData`
/// - Retry on 401 error by passing true to shouldRetryOn401 paramter - also need to pass reauthenticate block to NL.reauthenticateBlock
/// - Progress block for uploading and downloading request to get current progress by ((Double)-> Void) block
public class NLBaseAPI {
    
    //MARK: Properties
    /// Main provider with MultiTarget TargetType
    public let provider: MoyaProvider<MultiTarget>
    
    // Failure completion block
    typealias failureCompletion = (TargetType, Int, [String:Any]) -> ()
    // Success completion block with cached boolean
    typealias sucessCompletion<M:Mappable> = (M?, Bool) -> ()
    
    //MARK: Singleton
    public static let `default`: NLBaseAPI = NLBaseAPI()
    
    /// Main init for NLBaseAPI
    /// - Parameter provider: MoayProvider with multitarget used by this instance of NLBaseAPI - defaults to MoyaProvider<MultiTarget>.NLDefaultProvider()
    init(provider:MoyaProvider<MultiTarget> = MoyaProvider<MultiTarget>.NLDefaultProvider()) {
        self.provider = provider
    }
    
    //MARK: Methods
    /// Send plain request with expected empty response
    /// - Parameters:
    ///   - target: TaregeType of current request
    ///   - shouldRetryOn401: if should attempt to retry on unauthorize response 401 by call reauthenticate from NLWrapper
    ///   - completion: completion block with results
    /// - Returns: CancellableRequest or nil if no network connection
    @discardableResult
    public func sendRequest<T: TargetType>(target: T,
                                           shouldRetryOn401: Bool = true,
                                           completion:@escaping NLCompletionVoid) -> CancellableRequest? {
        return fetchData(target: target, shouldRetryOn401: shouldRetryOn401, responseClass: NLBaseEmptyResponse.self) { (result, _)  in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Send request with expected mappable object returned
    /// - Parameters:
    ///   - target: TaregeType of current request
    ///   - shouldRetryOn401: if should attempt to retry on unauthorize response 401 by call reauthenticate from NLWrapper
    ///   - responseClass: Mappable response class
    ///   - progress: progress block (usually used with uploads and download)
    ///   - cachedResponseKey: for caching reponse data - skip this parameter to disable caching on this request
    ///   - completion: completion block with results
    /// - Returns: CancellableRequest or nil if no network connection
    @discardableResult
    public func fetchData<M: Mappable, T:TargetType>(target: T,
                                                     shouldRetryOn401: Bool = true,
                                                     responseClass: M.Type,
                                                     progress:NLProgressBlock? = nil,
                                                     cachedResponseKey: String? = nil,
                                                     completion:@escaping NLCompletionMappable<M>) -> CancellableRequest? {
        
        //Prepare retry block on failure
        let retryBlock: (Bool)->(()->()) = {  [weak self] shouldRetry in
            return { self?.fetchData(target: target, shouldRetryOn401: shouldRetry, responseClass: responseClass, progress: progress, cachedResponseKey: cachedResponseKey, completion: completion) }
        }
        //Check network reachability
        guard reachable(retryBlock(shouldRetryOn401)) else { return nil }
        //Competion and progress block handlers
        let fail:failureCompletion = { (target, code, userInfo) in
            completion(.failure(NSError(domain: target.baseURL.absoluteString, code: code, userInfo: userInfo)), false)
        }
        let success: sucessCompletion = { (mappable, cached) in
            completion(.success(mappable), cached)
        }
        let progressBlock:ProgressBlock = { (_ progressResponse:ProgressResponse) in
            progress?(progressResponse.progress)
        }
        //Check cached response
        if let cachedResponseKey = cachedResponseKey, let cachedResult = readCache(forKey: cachedResponseKey, responseClass: responseClass) {
            success(cachedResult, true)
        }
        //Make request and return cancellabeRequest handler
        return provider.request(MultiTarget(target),progress: progressBlock) { responseResult in
            switch responseResult {
            case .success(let moyaResponse):
                do {
                    let successResponse = try moyaResponse.filterSuccessfulStatusCodes() //Check for status error
                    if responseClass is NLBaseEmptyResponse.Type { return success(nil, false) } // Check if sendRequest with empty response
                    guard let mappedObject = Mapper<M>().map(JSONObject: try successResponse.mapJSON()) else {
                        return fail(target, moyaResponse.statusCode, [NSLocalizedDescriptionKey: NLBaseErrorMessage.decodeError])
                    }
                    //Cache reponse data if applicable
                    self.writeCache(forKey: cachedResponseKey, data: successResponse.data)
                    success(mappedObject, false)
                }catch {
                    if let errorObject = Mapper<NLBaseError>().map(JSONObject: try? moyaResponse.mapJSON()) {
                        // Check if 401 status and has authenicate block from NL wrapper
                        if errorObject.code == 401, shouldRetryOn401, let reauthenticateBlock = NL.reauthenticateBlock {
                            //Note: retryBlock(false), here set to false to break retry on fail indefinitely
                            return reauthenticateBlock(retryBlock(false))
                        }
                        return fail(target, moyaResponse.statusCode, [NSLocalizedDescriptionKey: self.parseError(errors: errorObject.errors ?? [])])
                    }
                    return fail(target, moyaResponse.statusCode, [NSLocalizedDescriptionKey: NLBaseErrorMessage.genericErrorMessage])
                }
                
            case .failure(let moyaError):
                return fail(target, moyaError.errorCode, moyaError.errorUserInfo)
            }
        }.cancellableRequest
    }
    
    /// Check reachability with ReachabillityManager and fire notfication for failed request containing last failed request as userInfo
    /// - Parameter request: last failed request
    /// - Returns: true if  valid internet connection
    private func reachable(_ request:@escaping ()->()) -> Bool {
        guard ReachabilityManager.shared.isConnectionValid else {
            let request:[String:()->()] = [NL.configuration.apiConnectionFailureUserInfoKey:request]
            NotificationCenter.default.post(name: .NLApiConnectionFailure, object: self, userInfo: request)
            return false
        }
        return true
    }
    
    /// Parse error array of strings into one string multiple line
    /// - Parameter errors: Array of error string
    /// - Returns: one string error containing the error in erros array
    private func parseError(errors: [String]) -> String {
        var message = NLBaseErrorMessage.genericErrorMessage
        if !errors.isEmpty {
            message = ""
            let count = errors.count
            errors.forEach({message.append(count > 1 ? "-\($0)\n" : "\($0)\n")})
            message.removeLast(1)
        }
        return message
    }
    
    /// Read cached reponse data and return mappable object
    /// - Parameters:
    ///   - forKey: Key for cached mappable object
    ///   - responseClass: Mappable object responseClass
    /// - Returns: Mappable object contained in the cached response
    private func readCache<M: Mappable>(forKey: String, responseClass: M.Type) -> M? {
        guard let cachedData = NL.cacheManager.readData(forKey: forKey) else { return nil }
        let cachedResponse: Response = Response(statusCode: 200, data: cachedData)
        let mappedObject = Mapper<M>().map(JSONObject: try? cachedResponse.mapJSON())
        return mappedObject
    }
    
    /// Write cached response data
    /// - Parameters:
    ///   - forKey: Key for caching data
    ///   - data: Reponse data
    private func writeCache(forKey: String?, data: Data) {
        guard let forKey = forKey else { return }
        NL.cacheManager.write(data: data, forKey: forKey)
    }
    
}
