//
//  MRReversePusher.swift
//  RxSwiftBridgeTest
//
//  Created by Chris Fraser on 19/07/2015.
//  Copyright (c) 2015 Chris Fraser. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper

class MRSingleShotReversePusher<T: Mappable> : MRReversePusher<T> {
    var data: T?
    
    override init() {
        super.init()
        data = nil
    }
    
    override func addSubscriber(observer: ObserverOf<T>) -> Disposable {
        var key = super.subscribers.put(observer)
        if (data != nil) {
            sendNext(observer, data!)
            sendCompleted(observer)
        }
        return PusherSubscription(key: key, pusher: self)
    }
    
    override func pushJSON(json: String) {
        super.pushJSON(json)
        super.complete()
    }
}