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

class MRMappableReversePusher<T: MRMappable> : MRMappableReversePusherProtocol {
    typealias KeyType = Bag<Void>.KeyType
    
    var subscribers: Bag<ObserverOf<T>>
    
    init() {
        subscribers = Bag<ObserverOf<T>>()
    }
    
    func addSubscriber(observer: ObserverOf<T>) -> Disposable {
        var key = subscribers.put(observer)
        return PusherSubscription(key: key, pusher: self)
    }
    
    func removeSubscriber(key: KeyType) {
        subscribers.removeKey(key)
    }
    
    func push(object: AnyObject) {
        if let realObject = object as? T {
            self.pushUnwrapped(realObject)
        }
    }
    
    func pushUnwrapped(data: T) {
        for subscriber in subscribers.all {
            sendNext(subscriber, data)
        }
    }
    
    func complete() {
        for subscriber in subscribers.all {
            sendCompleted(subscriber)
        }
    }
    
    func error(error: ErrorType) {
        for subscriber in subscribers.all {
            sendError(subscriber, error)
        }
    }
}