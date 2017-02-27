//
//  AppInfoModel.swift
//  CheckVersion_Swift
//
//  Created by lee on 17/2/24.
//  Copyright © 2017年 hang. All rights reserved.
//

import Foundation

class AppInfoModel : NSObject {
    /** 版本号*/
    var version : AnyObject?
    /** bundleId*/
    var bundleId : AnyObject?
    /** 当前版本更新时间*/
    var currentVersionReleaseDate : AnyObject?
    /** APP简介*/
    var appDescription : AnyObject?
    /** 更新日志*/
    var releaseNotes : AnyObject?
    /** APPId*/
    var trackId : AnyObject?
    /** AppStore地址*/
    var trackViewUrl : AnyObject?
    /** App文件大小*/
    var fileSizeBytes : AnyObject?
    /** 开发商*/
    var sellerName : AnyObject?
    /** 展示图*/
    var screenshotUrls : [AnyObject]?
    
    
    init(dic:[String:AnyObject]) {
        super.init()
        
        self.version = dic["version"] 
        self.releaseNotes = dic["releaseNotes"] 
        self.currentVersionReleaseDate = dic["currentVersionReleaseDate"] 
        self.trackId = dic["trackId"] 
        self.bundleId = dic["bundleId"] 
        self.trackViewUrl = dic["trackViewUrl"] 
        self.appDescription = dic["appDescription"] 
        self.sellerName = dic["sellerName"] 
        self.fileSizeBytes = dic["fileSizeBytes"] 
        self.screenshotUrls = dic["screenshotUrls"] as! [AnyObject]?
    }
    
}


