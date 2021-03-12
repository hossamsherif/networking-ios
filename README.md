# NetworkLayerSwift

[![CI Status](https://img.shields.io/travis/hossamsherif/NetworkLayer.svg?style=flat)](https://travis-ci.org/hossamsherif/NetworkLayer)
[![Version](https://img.shields.io/cocoapods/v/NetworkLayer.svg?style=flat)](https://cocoapods.org/pods/NetworkLayer)
[![License](https://img.shields.io/cocoapods/l/NetworkLayer.svg?style=flat)](https://cocoapods.org/pods/NetworkLayer)
[![Platform](https://img.shields.io/cocoapods/p/NetworkLayer.svg?style=flat)](https://cocoapods.org/pods/NetworkLayer)

NetworkLayer is a network wrapper built up on [Moya](https://github.com/Moya/Moya) network library and [ObjectMapper](https://github.com/tristanhimmelman/ObjectMapper)

Features:
- API request for:
    - sending plain request via `sendRequest` which only success and failure
    - fetching data request via `fetchData` which return success with mappable object result or failure with error
- ReachabilityManager with configuration for Keys and NotificationCenter - Built over [`ReachabilitySwift`](https://github.com/ashleymills/Reachability.swift)
- Send notification when network connection is unreachable with the last failed api call - usefully for handling retry and auto reconnecting
- Caching response by providing cachedResponseKey - only available for `fetchData` - Built over [`DataCache`](https://github.com/huynguyencong/DataCache)
- Retry on 401 error by passing true to shouldRetryOn401 paramter - also need to pass reauthenticate block to NL.reauthenticateBlock
- Progress block for uploading and downloading request to get current progress by ((Double)-> Void) block
- CancellableRequest wrapper to cancel request and check request status

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

NetworkLayer is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'NetworkLayerSwift'
```

## Usage
Plain API calls:
```swift
enum ExampleTarget: TargetType {
    case getMessage
    case getPlain
    ...
}
...
 //Plain request without response
let getPlainRequest = NL.sendRequest(target: ExampleTarget.getPlain) { (result)
    switch result {
    case .success:
    ...
    case .failure(let error): 
    ...
    }
}
//To cancel request
getPlainRequest.cancel()
```
Fetch data with cache (caching by providing cachedResponseKey)
```swift
NL.fetchData(target: ExampleTarget.getMessage,
             responseClass: NLBaseResponse<MessageModel>.self,
             cachedResponseKey: ExampleTarget.getMessage.path) { (result, cached) in
    switch result {
    case .success(let response):
    let messageModel = response?.data // of type MessageModel
    let isCached = cached // will be true when returned from local cache
    ...
    case .failure(let error):
    ...
    }
}
```
Fetch data without cache (skip cachedResponseKey to disable cache)
```swift
NL.fetchData(target: ExampleTarget.getMessage,
             responseClass: NLBaseResponse<MessageModel>.self) { (result, _) in
    switch result {
    case .success(let response):
    let messageModel = response?.data 
    ...
    case .failure(let error):
    ...
    }
}
```
Retry on 401 unauthorized error
```swift
NL.reauthenticateBlock = { retryBlock in
// call you authenticatation api
authenticate(user) { result in
    switch result {
    case .success:
    ...
    retryBlock()
    case. failure:
    ...
    //should skip calling retrtBlock
    }
}
```
Hanling retry with auto calling last failed api when connection is restored
```swift

NotificationCenter.default.addObserver(self, selector: #selector(apiDidFail(_:)), name: .NLApiConnectionFailure, object: nil)
NotificationCenter.default.addObserver(self, selector: #selector(connectionDidChange(_:)), name: .NLDidChangeConnection, object: nil)

var failedRequests = [(()->())]()

@objc func connectionDidChange(_ notification:Notification) {
    if let connectionState = notification.userInfo?[NL.reachabilityConfiguration.didChangeConnectionUserInfoKey] as? ConnectionType,
        [.wifi, .cellular].contains(connectionState)  { // connection restored
        let retryRequest = failedRequests.popLast()
        retryRequest?()
    }    
}

@objc func apiDidFail(_ notification:Notification) {
    if let failedRquest = notification.userInfo?[NL.configuration.apiConnectionFailureUserInfoKey] as? () -> () {
        self.failedRequests.append(failedRquest)
    }
}

```
`Note:` Should be set before making any api call.
## Author

hossamsherif, hossam.sherif21@gmail.com

## License

NetworkLayer is available under the MIT license. See the LICENSE file for more info.
