//
//  NetworkManger.swift
//  AppleFeeds
//
//  Created by Sathish Kumar G on 9/30/20.
//  Copyright © 2020 Sathish Kumar G. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared : NetworkManager = {
        let instance = NetworkManager()
        return instance
    }()
    
    //Check for Network Availabilty
    func isConnected() -> Bool {
           if let networkReachability = NetworkReachabilityManager() {
               return networkReachability.isReachable
           } else {
               return false
           }
       }

    func alamofireRequest(urlString : String, completionHandler: @escaping (Bool, Welcome?) ->()) {
    
        if self.isConnected() {
            AF.request(urlString).responseDecodable(of: Welcome.self) { (response) in
                guard let newData = response.value else {
                    completionHandler(false, nil)
                    return
                }
              completionHandler(true, newData)
            }
        } else {
            print("No Network")
        }
    }
}

