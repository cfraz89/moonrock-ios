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
import EVReflection

class MRStreamManager : NSObject, WKScriptMessageHandler {
    var pushers: [String: MRReversePusherProtocol]
    
    override init() {
        self.pushers = [String: MRReversePusherProtocol]()
        super.init()
       
    }
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        let body = message.body as! [String: AnyObject]
        let streamName = body["streamName"] as! String
        if let pusher = self.pushers[streamName] {
            pusher.pushDictionary(body)
        }
    }
    
    func openStream<T>(key:String, pusher: MRReversePusher<T>) -> Observable<T> {
        pushers[key] = pusher
        return create { subscriber in
            return pusher.addSubscriber(subscriber)
        }
    }

}