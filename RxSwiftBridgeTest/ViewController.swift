//
//  ViewController.swift
//  RxSwiftBridgeTest
//
//  Created by Chris Fraser on 7/07/2015.
//  Copyright (c) 2015 Chris Fraser. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet weak var Add1: UITextField!
    @IBOutlet weak var Add2: UITextField!
    @IBOutlet weak var AddButton: UIButton!
    @IBOutlet weak var AddResult: UILabel!
    @IBOutlet weak var TableView: UITableView!
    var moonRock: MoonRock;
    var module: MoonRockModule?
    var disposeBag = DisposeBag()
    var postsDataSource: PostsDataSource
    
    var addPressed: Observable<NSObject>?
    var add1Text: Observable<NSString>?
    var add2Text: Observable<NSString>?
    
    var sum: Observable<String>?
    var posts: Observable<PostList>?

    
    required init(coder aDecoder: NSCoder) {
        self.moonRock = MoonRock().prepare()
        self.postsDataSource = PostsDataSource(posts:[])
        super.init(coder: aDecoder)
        
        self.moonRock.baseUrl = "http://localhost:8081"
        self.moonRock.loadModule("app/appmodule", instanceName: "appmodule", host: self)
            >- subscribeNext(self.setupPortals)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.TableView.dataSource = self.postsDataSource
        
        self.addPressed = AddButton.rx_tap >- map { NSObject() }
        self.add1Text = Add1.rx_text >- map { NSString(string: $0) }
        self.add2Text = Add2.rx_text >- map { NSString(string: $0) }
    }
    
    func setupPortals(module: MoonRockModule) {
        self.module = module
        module.portal(addPressed!, name: "addPressed")
        module.portal(add1Text!, name: "add1Text")
        module.portal(add2Text!, name: "add2Text")
        sum = module.reversePortal("sum")
        posts = module.reversePortal("posts")
    }
}