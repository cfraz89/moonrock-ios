//
//  MRReversePusher.swift
//  RxSwiftBridgeTest
//
//  Created by Chris Fraser on 19/07/2015.
//  Copyright (c) 2015 Chris Fraser. All rights reserved.
//

import Foundation
import RxSwift
import EVReflection

class MRReversePusher<T: NSObject> : MRReversePusherProtocol {
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
    
    func push (data: AnyObject) {
        if let dict = data as? NSDictionary {
            var object = T()
            object.setValuesForKeysWithDictionary(dict as [NSObject : AnyObject])
            self.push(object)
        }
        else {
            self.push(data as! T)
        }
    }
    
    func push(data: T) {
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