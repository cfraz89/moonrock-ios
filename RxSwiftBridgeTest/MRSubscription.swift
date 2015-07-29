//
//  Subscription.swift
//  RxSwiftBridgeTest
//
//  Created by Chris Fraser on 30/07/2015.
//  Copyright (c) 2015 Chris Fraser. All rights reserved.
//

import Foundation
import RxSwift

protocol MRSubscription {
    func removeSubscriber(key: Bag<Void>.KeyType)
}