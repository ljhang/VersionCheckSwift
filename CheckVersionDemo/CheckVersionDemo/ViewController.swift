//
//  ViewController.swift
//  CheckVersionDemo
//
//  Created by lee on 17/2/25.
//  Copyright © 2017年 lee. All rights reserved.
//

import UIKit
import Version

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let checkMgr = CheckVersionMgr.shareInstance
        checkMgr.openTrackUrlInAppStore = false
        checkMgr.CheckAgainInterval = 60*24
        checkMgr.checkVersionWithSystemAlert()
        checkMgr.getVersionInfo(completed: { (info) in
            
        }) { (error) in
            
        }
        checkMgr.checkVersionWithCustomView { (model, status) in
            //code
        }
        
        let versionKit = VersionKit.shareInstance
        versionKit.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: VersionKitDelegate {
    func versionKitWithBundleID() -> String? {
        return "com.nowgoal.sports"
    }
}
