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
    var mrMapperPortals: [String: MRMappableReversePusherProtocol]
    
    override init() {
        self.portals = [String: MRReversePusherProtocol]()
        self.mrMapperPortals = [String: MRMappableReversePusherProtocol]()
        super.init()
    }
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        let body = message.body as! [String: AnyObject]
        let portalName = body["portalName"] as! String
        
        var pusher = self.portals[portalName]

        if let objectData = body["data"] as? [String: AnyObject] {
            self.portals[portalName]?.push(objectData)
        } else {
            var data = body["data"]
            self.mrMapperPortals[portalName]?.push(data!)
        }
        
        
    }
    
    func registerReverse<T: Mappable>(name: String, type: T.Type) -> MRReversePusher<T> {
        let pusher = MRReversePusher<T>()
        self.portals[name] = pusher
        return pusher
    }
    
    func registerReverse<T: MRMappable>(name: String, type: T.Type) -> MRMappableReversePusher<T> {
        let pusher = MRMappableReversePusher<T>()
        self.mrMapperPortals[name] = pusher
        return pusher
    }
}