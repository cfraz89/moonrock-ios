//
//  BridgeNavigationDelegate.swift
//  RxSwiftBridgeTest
//
//  Created by Chris Fraser on 8/07/2015.
//  Copyright (c) 2015 Chris Fraser. All rights reserved.
//

import Foundation
import WebKit
import RxSwift

class MRNavigationDelegate : NSObject, WKNavigationDelegate {
    weak var readySubject: PublishSubject<MoonRock>?
    var baseUrl: String
    weak var moonRock: MoonRock?
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
        super.init()
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        var config = String(format:"System.config({baseURL:'%@'});" +
            "window.streamInterface=webkit.messageHandlers.streamInterface;" +
            "window.reversePortalInterface=webkit.messageHandlers.reversePortalInterface;", baseUrl);
        webView.evaluateJavaScript(config, completionHandler: { (object: AnyObject!, error: NSError!) -> Void in
            sendNext(self.readySubject!, self.moonRock!)
            sendCompleted(self.readySubject!)
        })
    }
}