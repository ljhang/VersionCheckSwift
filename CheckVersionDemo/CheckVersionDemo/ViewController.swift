//
//  ViewController.swift
//  CheckVersionDemo
//
//  Created by lee on 17/2/25.
//  Copyright © 2017年 lee. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let checkMgr = CheckVersionMgr.shareInstance
        //checkMgr.openTrackUrlInAppStore = false
        
        checkMgr.checkVersionWithSystemAlert()
        
        checkMgr.checkVersionWithCustomView { (model) in
            //code
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

