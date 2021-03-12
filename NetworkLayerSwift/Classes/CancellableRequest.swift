//
//  CancellableRequest.swift
//  NetworkLayer
//
//  Created by Hossam Sherif on 11/2/20.
//  Copyright © 2020 Rubikal. All rights reserved.
//

import Foundation
import Moya

public protocol CancellableRequest {
    /// A Boolean value stating whether a request is cancelled.
    var isCancelled: Bool { get }
    /// Cancels the represented request.
    func cancel()
}

class CancellableAdapter: CancellableRequest {
    private var canncellable:Cancellable?

    init(canncellable: Cancellable?) {
        self.canncellable = canncellable
    }

    /// A Boolean value stating whether a request is cancelled.
    var isCancelled: Bool {
        return canncellable?.isCancelled ?? false
    }

    /// Cancels the represented request.
    func cancel() {
        canncellable?.cancel()
    }
}

extension Cancellable {
    var cancellableRequest:CancellableRequest {
        return CancellableAdapter(canncellable: self)
    }
}
