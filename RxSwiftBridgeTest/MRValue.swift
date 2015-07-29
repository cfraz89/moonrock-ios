//
//  MRPortalEntity.swift
//  RxSwiftBridgeTest
//
//  Created by Chris Fraser on 29/07/2015.
//  Copyright (c) 2015 Chris Fraser. All rights reserved.
//

import Foundation
import ObjectMapper

class MRValue<T> : Mappable {
    var data: T?
    
    static func newInstance() -> Mappable {
        return MRValue<T>(data: nil)
    }
    
    init(data: T?) {
        self.data = data
    }
    
    func mapping(map: Map) {
        data <- map["data"]
    }
}