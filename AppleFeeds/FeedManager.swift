//
//  FeedManager.swift
//  AppleFeeds
//
//  Created by Sathish Kumar G on 9/30/20.
//  Copyright © 2020 Sathish Kumar G. All rights reserved.
//

import Foundation
import JGProgressHUD

class FeedManager {
    
    let hud = JGProgressHUD(style: .dark)
    
    func getFeedResult(urlString: String, completionHandler: @escaping (Feed?) ->()) {
        let feedUrlString = urlString
        NetworkManager.shared.alamofireRequest(urlString: feedUrlString, completionHandler:{ isfetchSuccess, receivedModel in
            if isfetchSuccess {
                print("Success")
                guard let welcomeModel = receivedModel else {
                    completionHandler(nil)
                    return
                }
                completionHandler(welcomeModel.feed)
            } else {
                print("fail")
                self.hideHUD()
                completionHandler(nil)
            }
        })
    }
    
    func showSuccessHUD(thisView :UIView) {
        self.hideHUD()
        hud.indicatorView = JGProgressHUDSuccessIndicatorView.init()
        hud.textLabel.text = Constants.success
        hud.show(in: thisView)
        hud.dismiss(afterDelay: 1.0)
    }
    
    func showHUD(thisView :UIView) {
        hud.textLabel.text = Constants.loading
        hud.show(in: thisView)
    }
    
    func hideHUD() {
        hud.dismiss()
    }
}

