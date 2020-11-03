//
//  ViewController.swift
//  NetworkLayer
//
//  Created by hossamsherif on 11/02/2020.
//  Copyright © 2020 Rubikal. All rights reserved.
//

import UIKit
import NetworkLayer
import ObjectMapper


class ViewController: UIViewController {

    let testNetwork:NetworkProviderProtocol = NetworkProvider()
    
    @IBOutlet weak var testPlainResult: UILabel!
    @IBOutlet weak var testPlainWithResponseResult: UILabel!
    
    var failedRequests = [(()->())]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(apiDidFail(_:)), name: .NLApiConnectionFailure, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(connectionDidChange(_:)), name: .NLDidChangeConnection, object: nil)
        NL.reauthenticateBlock =  { retryBlock in
            print("athenticate")
            retryBlock()
        }
        NL.configuration = NLConfiguration(enableLogging: true)
    }
    
    @objc func connectionDidChange(_ notification:Notification) {
        if let connectionState = notification.userInfo?[NL.reachabilityConfiguration.didChangeConnectionUserInfoKey] as? NLConnectionType,
            [.wifi, .cellular].contains(connectionState) { // connected
            let retryRequest = failedRequests.popLast()
            retryRequest?()
        }
        
    }
    
    @objc func apiDidFail(_ notification:Notification) {
        if let failedRquest = notification.userInfo?[NL.configuration.apiConnectionFailureUserInfoKey] as? () -> () {
            self.failedRequests.append(failedRquest)
        }
    }
    
    @IBAction func retryBtnAction(_ sender: Any) {
        if ReachabilityManager.shared.isConnectionValid {
            let retryRequest = failedRequests.popLast()
            retryRequest?()
        }
    }
    @IBAction func testPlain(_ sender: Any?) {
        testNetwork.getPlain { [weak self] (result) in
            switch result {
            case .success:
                print("success")
                self?.testPlainResult.text = "Success"
            case .failure(let error):
                self?.testPlainResult.text = "Error: \(error.localizedDescription)"
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func testPlainWithResponse(_ sender: Any?) {
        testNetwork.getHello{ [weak self] (result, cached) in
            switch result {
            case .success(let helloModel):
                print("success: \(helloModel?.hello ?? "no message") cached:\(cached)")
                self?.testPlainWithResponseResult.text = "Success: \(helloModel?.hello ?? "NO MESSAGE")"
            case .failure(let error):
                self?.testPlainWithResponseResult.text = "Error:\(error.localizedDescription)"
                print("error: \(error.localizedDescription)")
            }
        }
    }
}

