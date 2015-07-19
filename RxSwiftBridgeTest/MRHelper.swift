//
//  MRHelper.swift
//  RxSwiftBridgeTest
//
//  Created by Chris Fraser on 19/07/2015.
//  Copyright (c) 2015 Chris Fraser. All rights reserved.
//

import Foundation

class MRHelper {
    let helper = "mrhelper"
    let moonrock: MoonRock
    
    init(moonrock: MoonRock) {
        self.moonrock = moonrock
    }
    
    func run(function: String, args: String...) {
        var argsList = args.map({"'\($0)'"})
        var runScript = String(format: "%@.%@(%@)", helper, function, ",".join(argsList))
        self.moonrock.runJS(runScript, callback: nil)
    }
}