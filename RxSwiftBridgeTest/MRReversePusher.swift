//
//  MRReversePusher.swift
//  RxSwiftBridgeTest
//
//  Created by Chris Fraser on 19/07/2015.
//  Copyright (c) 2015 Chris Fraser. All rights reserved.
//

import Foundation
import RxSwift

class MRReversePusher<T> {
    private var subscribers: Bag<ObserverOf<T>>

    init() {
        subscribers = Bag<ObserverOf<T>>()
    }
    
    func addSubscriber(observer: ObserverOf<T>) -> Disposable {
        var key = subscribers.put(observer)
        return AnonymousDisposable {}
    }
    
    func removeSubscriber(key: String) {
        //subscribers.removeKey(key)
    }
    
    func push(data: T) {
        
    }
}