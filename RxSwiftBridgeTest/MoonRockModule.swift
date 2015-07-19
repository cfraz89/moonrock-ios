//
//  ScriptModule.swift
//  RxSwiftBridgeTest
//
//  Created by Chris Fraser on 8/07/2015.
//  Copyright (c) 2015 Chris Fraser. All rights reserved.
//

import Foundation
import EVReflection
import RxSwift

class MoonRockModule {
    let moonrock: MoonRock
    let mrhelper: MRHelper
    var moduleName: String?
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
        self.mrhelper.run("loadModule", args: "module")
        
        var pusher = MRReversePusher<String>()
        var loaded = self.moonrock.streamManager.openStream(self.loadedName, pusher: pusher)
        loaded >- subscribeNext {_ in
            sendNext(self.ready, self)
            sendCompleted(self.ready)
        }
        
        return self.ready
    }
    
     func function<T: EVObject>(function: String, streamName: String, streamType: T) -> Observable<T> {
        var resultObservable = PublishSubject<T>()
        let formattedScript = String(format: "%@.%@(\"%@\")", self.loadedName, function, streamName)
        return resultObservable
    }
    
    func portal<T>(observable: Observable<T>, name: String) {
        mrhelper.run("portal", args: self.loadedName, name)
    }
    
    func reversePortal<T>(name: String) -> Observable<T> {
        return create { observer in
            return AnonymousDisposable {}
        }
    }
    
    func portalsGenerated() {
        portalsGeneratedBehind = true
    }
    
    func portalsLinked() {
    
    }
}