//
//  MRMappable.swift
//  RxSwiftBridgeTest
//
//  Created by Chris Fraser on 29/07/2015.
//  Copyright (c) 2015 Chris Fraser. All rights reserved.
//

import Foundation
import ObjectMapper

protocol MRMappable {
    func toJson() -> String?
    func fromJson(json: String) -> Self?
}