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
    
    /// 根控制器
    static var rootViewController: UIViewController? {
        if let window = UIApplication.shared.keyWindow {
            return window.rootViewController
        }
        return nil
    }
    
    // MARK: - version
    
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
    
    // MARK: - date
    
    /// 字符串转换为日期
    ///
    /// - Parameters:
    ///   - dateString: 需转换日期
    ///   - dateFormat: 日期格式
    /// - Returns: Date
    static func stringToDate(_ dateString: String, _ dateFormat: String = "yyyy-MM-dd HH:mm") -> Date? {
        let format = Tools.customDateFormatter
        format.dateFormat = dateFormat
        return format.date(from: dateString)
    }
    
    static func dateToString(_ date: Date = Date(), _ dateFormat: String = "yyyy-MM-dd HH:mm") -> String {
        let format = Tools.customDateFormatter
        format.dateFormat = dateFormat
        return format.string(from: date)
    }
    
    /// 自定义日期格式
    static var customDateFormatter: DateFormatter {
        let dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.system
        dateFormatter.timeZone = NSTimeZone.system
        return dateFormatter
    }
}

