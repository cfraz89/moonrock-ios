    //
//  ScriptModule.swift
//  RxSwiftBridgeTest
//
//  Created by Chris Fraser on 8/07/2015.
//  Copyright (c) 2015 Chris Fraser. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper

class MoonRockModule {
    let moonrock: MoonRock
    let mrhelper: MRHelper
    var moduleName: String
    let loadedName: String
    
    var portalHost: NSObject
    var portalsGeneratedBehind: Bool
    
    var ready: PublishSubject<MoonRockModule>
    
    init(moonrock: MoonRock, module: String, loadedName: String, portalHost: NSObject, ready: PublishSubject<MoonRockModule>) {
        self.moonrock = moonrock
        self.mrhelper = MRHelper(moonrock: moonrock)
        self.moduleName = module
        self.loadedName = loadedName
        self.portalHost = portalHost
        self.ready = ready
        self.portalsGeneratedBehind = false
    }
    
    func load() -> PublishSubject<MoonRockModule> {
        self.mrhelper.run("loadModule", args: self.moduleName, self.loadedName)
        
        var pusher = MRReversePusher<MRValue<Int>>()
        var loaded = self.moonrock.streamManager.openStream(self.loadedName, pusher: pusher)
        loaded >- subscribeNext {_ in
            sendNext(self.ready, self)
            sendCompleted(self.ready)
        }
        
        return self.ready
    }
    
     func function<T>(function: String, streamName: String, streamType: T) -> Observable<T> {
        var resultObservable = PublishSubject<T>()
        let formattedScript = String(format: "%@.%@(\"%@\")", self.loadedName, function, streamName)
        return resultObservable
    }
    
    func portal<T>(observable: Observable<T>, name: String) {
        mrhelper.run("portal", args: self.loadedName, name)
        observable >- subscribeNext { data in
            var portalValue = MRValue<T>(data: data)
            if let jsonString = Mapper().toJSONString(portalValue, prettyPrint: false) {
                self.mrhelper.run("activatePortal", args: self.loadedName, name, jsonString)
            }
        }
    }
    
    func reversePortal<T: Mappable>(name: String, type: T.Type) -> Observable<T> {
        let pusher = self.moonrock.reversePortalManager.registerReverse(name, type: type)
        mrhelper.run("reversePortal", args: self.loadedName, name)
        return create { observer in
            return pusher.addSubscriber(observer)
        }
    }
    
    func portalsGenerated() {
        portalsGeneratedBehind = true
        mrhelper.run("portalsGenerated", args: self.loadedName)
    }
    
    func portalsLinked() {
    
    }
}