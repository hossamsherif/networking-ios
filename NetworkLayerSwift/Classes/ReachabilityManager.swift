//
//  ReachabilityManager.swift
//  NetworkLayer
//
//  Copyright © 2020 Rubikal. All rights reserved.
//

import Foundation
import Reachability

public enum NLConnectionType: String {
    case cellular = "Cellular"
    case wifi = "WiFi"
    case none = "No Connection"
}

public class ReachabilityManager {
    // MARK:- Properties
    public var isConnectionValid: Bool {
        return reachability.connection != .unavailable
    }
    
    public var connectionType: NLConnectionType? {
        return NLConnectionType(rawValue: reachability.connection.description)
    }
    
    private let reachability: Reachability
    
    // MARK:- Singleton
    
    public static let shared = ReachabilityManager()
    
    private init() {
        self.reachability = try! Reachability()
    }
    
    // MARK:- Methods
    func startMonitoring() {
        reachability.whenReachable = { reachability in
            self.postNotification(state: reachability.connection.description)
        }
        reachability.whenUnreachable = { reachability in
            self.postNotification(state: reachability.connection.description)
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    private func postNotification(state: String) {
        let connectionType = NLConnectionType(rawValue: state)
        if let connectionType = connectionType {
            NotificationCenter.default.post(name: .NLDidChangeConnection, object: self, userInfo: [NL.reachabilityConfiguration.didChangeConnectionUserInfoKey: connectionType])
        }
    }
    
    func stopMonitoring() {
        reachability.stopNotifier()
    }
}
