//
//  PusherSubscription.swift
//  RxSwiftBridgeTest
//
//  Created by Chris Fraser on 22/07/2015.
//  Copyright (c) 2015 Chris Fraser. All rights reserved.
//

import Foundation
import RxSwift

class PusherSubscription : Disposable {
    typealias KeyType = Bag<Void>.KeyType
    private var pusher: MRSubscription?
    private var key: KeyType?
    
    init(key: KeyType, pusher: MRSubscription) {
        self.key = key
        self.pusher = pusher
        
    }
    
    func dispose() {
        self.pusher!.removeSubscriber(self.key!)
        self.key = nil
        self.pusher = nil
    }
    
}
