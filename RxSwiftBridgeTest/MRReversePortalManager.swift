//
//  MRReversePortalManager.swift
//  RxSwiftBridgeTest
//
//  Created by Chris Fraser on 16/07/2015.
//  Copyright (c) 2015 Chris Fraser. All rights reserved.
//

import Foundation
import WebKit

class MRReversePortalManager : NSObject, WKScriptMessageHandler {
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        let body = message.body as! NSDictionary
        let data = body["data"]
        let portalName = body["portalName"] as! String
    }
}