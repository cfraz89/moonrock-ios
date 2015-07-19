//
//  MRStreamManager.swift
//  RxSwiftBridgeTest
//
//  Created by Chris Fraser on 16/07/2015.
//  Copyright (c) 2015 Chris Fraser. All rights reserved.
//

import Foundation
import WebKit
import RxSwift

class MRStreamManager : NSObject, WKScriptMessageHandler {
    var pushers: [String: MRReversePusherProtocol]
    
    override init() {
        self.pushers = [String: MRReversePusherProtocol]()
        super.init()
       
    }
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        let bridgeMessage = message.body as! NSDictionary
        let data = bridgeMessage["data"]
        let streamName = bridgeMessage["stream"] as! String
        
        if let pusher = self.pushers[streamName] {
            pusher.push(data as! String)
        }
    }
    
    func openStream<T>(key:String, pusher: MRReversePusher<T>) -> Observable<T> {
        pushers[key] = pusher
        return create { subscriber in
            return pusher.addSubscriber(subscriber)
        }
    }

}