//
//  MRExtensions.swift
//  RxSwiftBridgeTest
//
//  Created by Chris Fraser on 29/07/2015.
//  Copyright (c) 2015 Chris Fraser. All rights reserved.
//

import Foundation
import ObjectMapper

extension String: MRMappable {
    func toJson() -> String? {
        return self
    }
    
    func fromJson(json: String) -> String? {
        return json
    }
}

extension Int: MRMappable {
    func toJson() -> String? {
        return String(self)
    }
    
    func fromJson(json: String) -> Int? {
        return json.toInt()
    }
}