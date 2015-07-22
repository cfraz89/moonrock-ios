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
        var config = "prep('\(baseUrl)', 'ios')";
        webView.evaluateJavaScript(config, completionHandler: nil)
    }
}