//
//  Post.swift
//  RxSwiftBridgeTest
//
//  Created by Chris Fraser on 8/07/2015.
//  Copyright (c) 2015 Chris Fraser. All rights reserved.
//

import Foundation
import ObjectMapper

class Post: Mappable {
    var title: String?
    var body: String?
    
    static func newInstance() -> Mappable {
        return Post()
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        body  <- map["body"]
    }
}