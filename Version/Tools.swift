//
//  Tools.swift
//  Version
//
//  Created by hang on 6/7/18.
//  Copyright © 2018年 lee. All rights reserved.
//

import Foundation

/// 工具类
class Tools {
    
    /// 获取APP版本号
    ///
    /// - Returns: String
    static func getLocalVersion() -> String? {
        if let dict = Bundle.main.infoDictionary, let localversion = dict["CFBundleShortVersionString"] {
            return localversion as? String
        }
        return  nil
    }
    
    /// 比较本地版本号与线上版本号
    ///
    /// - Parameters:
    ///   - localVersion: 本地版本号
    ///   - itunesVersion: 线上版本号
    /// - Returns: 高于为True、低于为False
    static func compareVersion(_ localVersion:String, _ itunesVersion:String) -> Bool {
        if localVersion.compare(itunesVersion) == .orderedAscending {
            return true
        }
        return false
    }
}
