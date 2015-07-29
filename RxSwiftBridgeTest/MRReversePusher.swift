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

class MRReversePusher<T: Mappable> : MRReversePusherProtocol {
    typealias KeyType = Bag<Void>.KeyType
    
    var subscribers: Bag<ObserverOf<T>>
    
    let mapper: Mapper<T>

    init() {
        subscribers = Bag<ObserverOf<T>>()
        mapper = Mapper<T>()
    }
    
    func addSubscriber(observer: ObserverOf<T>) -> Disposable {
        var key = subscribers.put(observer)
        return PusherSubscription(key: key, pusher: self)
    }
    
    func removeSubscriber(key: KeyType) {
        subscribers.removeKey(key)
    }
    
    func pushJSON (json: String) {
        if let object = self.mapper.map(json) {
            self.push(object)
        }
    }
    
    func pushDictionary(dict: [String: AnyObject]) {
        if let object = self.mapper.map(dict) {
            self.push(object)
        }
    }
    
    func pushRaw(object: AnyObject) {
        if let realObject = object as? T {
            self.push(realObject)
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