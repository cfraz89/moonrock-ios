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
    
    var addPressed: Observable<Void>?
    var add1Text: Observable<String>?
    var add2Text: Observable<String>?
    
    var sum: Observable<String>?
    var posts: Observable<PostList>?

    
    required init(coder aDecoder: NSCoder) {
        self.moonRock = MoonRock().prepare()
        self.postsDataSource = PostsDataSource(posts:[])
        super.init(coder: aDecoder)
        
        self.moonRock.loadModule("app/appmodule", instanceName: "appmodule", host: self)
            >- subscribeNext(self.setupPortals)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.TableView.dataSource = self.postsDataSource
        
        self.addPressed = AddButton.rx_tap
        self.add1Text = Add1.rx_text
        self.add2Text = Add2.rx_text
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