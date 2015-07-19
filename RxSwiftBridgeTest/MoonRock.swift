//
//  JSBridge.swift
//  RxSwiftBridgeTest
//
//  Created by Chris Fraser on 7/07/2015.
//  Copyright (c) 2015 Chris Fraser. All rights reserved.
//

import Foundation
import WebKit
import EVReflection
import RxSwift

class MoonRock {
    let DEFAULT_BASE: String = "file:///"
    let DEFAULT_PAGE: String = "moonrock.html"
    
    let streamManager: MRStreamManager
    let reversePortalManager: MRReversePortalManager

    var loadedModules: Dictionary<String, MoonRockModule>
    var webView: WKWebView
    
    private var webViewNavigationDelegate: MRNavigationDelegate
    private let readySubject: PublishSubject<MoonRock>
    
    private var needsLoad: Bool
    private var _baseUrl: String;
    var baseUrl: String {
        get {
            return _baseUrl
        } set(value) {
            _baseUrl = value
            webViewNavigationDelegate.baseUrl = value;
        }
    }
    
    var pageUrl: String;
    
    init () {
        streamManager = MRStreamManager()
        reversePortalManager = MRReversePortalManager()
        loadedModules = Dictionary<String, MoonRockModule>()
        readySubject = PublishSubject<MoonRock>()
        
        needsLoad = true
        _baseUrl = DEFAULT_BASE
        pageUrl = DEFAULT_PAGE
        
        webViewNavigationDelegate = MRNavigationDelegate(baseUrl: _baseUrl)
        webView = WKWebView(frame: CGRect())
        webView.navigationDelegate = webViewNavigationDelegate
        setupWebView()
    }
    
    func prepare() -> MoonRock {
        webViewNavigationDelegate.readySubject = readySubject
        webViewNavigationDelegate.moonRock = self
        return self
    }
    
    func setupWebView() {
        var contentController = WKUserContentController()
        contentController.addScriptMessageHandler(reversePortalManager, name: "streamInterface")
        contentController.addScriptMessageHandler(streamManager, name: "reversePortalInterface")
        webView.configuration.userContentController = contentController
    }
    
    func load() {
        //var url = NSBundle.mainBundle().URLForResource("Assets/bridge", withExtension: "html");
        var url = NSURL(string: "http://localhost:8081/bridge.html")
        
        webView.loadRequest(NSURLRequest(URL: url!))
        webView.reloadFromOrigin()
    }
    
    func loadModule(moduleName: String, instanceName: String, host: NSObject) -> Observable<MoonRockModule> {
        if (needsLoad) {
            load()
        }
        var moduleReady = PublishSubject<MoonRockModule>()
        readySubject >- subscribeNext { ready in
            let instance = self.moduleNameForInstance(moduleName, instanceName: instanceName)
            if let module = self.loadedModules[instance] {
                module.portalHost = host
                sendNext(moduleReady, module)
                sendCompleted(moduleReady)
            } else {
                MoonRockModule(moonrock: self, module: moduleName, loadedName: instance, portalHost: host, ready: moduleReady).load()
                    >- subscribeNext { m in
                        self.loadedModules[instance] = m
                    }
            }
        }
        
        return moduleReady
    }
    
    private func moduleNameForInstance(module: String, instanceName: String) -> String {
        return String(format: "instance_%@_%@", module.stringByReplacingOccurrencesOfString("/", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil),instanceName)
    }
    
    
    var ready: Observable<MoonRock> {
        get {
            return readySubject
        }
    }
    
    func runJS(js: String, callback:((AnyObject!, NSError!)->Void)?) {
        self.webView.evaluateJavaScript(js, completionHandler: callback)
    }
}