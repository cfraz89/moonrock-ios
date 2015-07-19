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

class MRReversePusher<T> : MRReversePusherProtocol {
    typealias KeyType = Bag<Void>.KeyType
    
    private var subscribers: Bag<ObserverOf<T>>

    init() {
        subscribers = Bag<ObserverOf<T>>()
    }
    
    func addSubscriber(observer: ObserverOf<T>) -> Disposable {
        var key = subscribers.put(observer)
        return PusherSubscription<T>(key: key, pusher: self)
    }
    
    func removeSubscriber(key: KeyType) {
        subscribers.removeKey(key)
    }
    
    func push (data: String) {
        var object = EVReflection.swiftClassFromString(data) as! T
        self.push(object)
    }
    
    func push(data: T) {
        
        for subscriber in subscribers.all {
            var box = RxBox<T>(data)
            subscriber.on(Event<T>.Next(box))
        }
    }
    
    func complete() {
        for subscriber in subscribers.all {
            subscriber.on(Event<T>.Completed)
        }
    }
    
    func error(error: ErrorType) {
        for subscriber in subscribers.all {
            subscriber.on(Event<T>.Error(error))
        }
    }
}

class PusherSubscription<T> : Disposable {
    
    typealias KeyType = Bag<Void>.KeyType
    
    private var pusher: MRReversePusher<T>?
    private var key: KeyType?
    
    init(key: KeyType, pusher: MRReversePusher<T>) {
        self.key = key
        self.pusher = pusher
        
    }
    
    func dispose() {
        self.pusher!.removeSubscriber(self.key!)
        self.key = nil
        self.pusher = nil
    }

}
