//
//  MRReversePortalManager.swift
//  RxSwiftBridgeTest
//
//  Created by Chris Fraser on 16/07/2015.
//  Copyright (c) 2015 Chris Fraser. All rights reserved.
//

import Foundation
import WebKit
import ObjectMapper

class MRReversePortalManager : NSObject, WKScriptMessageHandler {
    var portals: [String: MRReversePusherProtocol]
    
    override init() {
        self.portals = [String: MRReversePusherProtocol]()
        super.init()
    }
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        let body = message.body as! [String: AnyObject]
        let portalName = body["portalName"] as! String
        
        var pusher = self.portals[portalName]

        if let objectData = body["data"] as? [String: AnyObject] {
            self.portals[portalName]?.pushDictionary(objectData)
        } else {
            var data = body["data"]
            self.portals[portalName]?.pushRaw(data!)
        }
        
        
    }
    
    func registerReverse<T>(name: String, type: T.Type) -> MRReversePusher<T> {
        let pusher = MRReversePusher<T>()
        self.portals[name] = pusher
        return pusher
    }
}