//
//  VersionKitBridge.swift
//  CheckVersionDemo
//
//  Created by 李建航 on 2018/7/10.
//  Copyright © 2018 lee. All rights reserved.
//

import Foundation
import Version

class VersionKitBridge {
    
    public static let shareInstance = VersionKitBridge()
    
    var versionKit: VersionKit {
        return VersionKit.shareInstance
    }
    
    init() {
        self.setup()
    }
    
    func setup() {
        versionKit.delegate = self
    }
    
    func reDetect() {
        versionKit.reDetected()
    }
}

extension VersionKitBridge: VersionKitDelegate {
    func versionKitWithBundleID() -> String? {
        return "com.nowgoal.sports"
    }
    
    func versionKitWithViewType() -> ViewAppType {
        return .inApp
    }
}
