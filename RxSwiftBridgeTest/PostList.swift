//
//  PostList.swift
//  RxSwiftBridgeTest
//
//  Created by Chris Fraser on 8/07/2015.
//  Copyright (c) 2015 Chris Fraser. All rights reserved.
//

import Foundation
import ObjectMapper

class PostList: Mappable {
    var data: [Post]?
    
    static func newInstance() -> Mappable {
        return PostList()
    }
    
    func mapping(map: Map) {
        data <- map["data"]
    }
}