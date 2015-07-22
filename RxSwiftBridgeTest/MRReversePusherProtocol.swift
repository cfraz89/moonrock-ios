//
//  MRReversePusherProtocol.swift
//  RxSwiftBridgeTest
//
//  Created by Chris Fraser on 20/07/2015.
//  Copyright (c) 2015 Chris Fraser. All rights reserved.
//

import Foundation
import RxSwift

protocol MRReversePusherProtocol {
    func push(data: AnyObject)
    func removeSubscriber(key: Bag<Void>.KeyType)
}