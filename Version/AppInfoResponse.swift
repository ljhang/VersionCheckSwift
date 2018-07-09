//
//  AppInfoResponse.swift
//  Version
//
//  Created by 李建航 on 2018/7/6.
//  Copyright © 2018 lee. All rights reserved.
//

import Foundation
import ObjectMapper

public class AppInfoResponse: Mappable {
    
    var resultCount: Int?
    
    var results: [AppInfoResults]?
    
    public required init?(map: Map) { }
    
    public func mapping(map: Map) {
        resultCount <- map["resultCount"]
        results <- map["results"]
    }
}


public class AppInfoResults: Mappable {
    
    var trackViewUrl: String?
    
    var releaseNotes: String?
    
    var trackId: Int?
    
    var trackName: String?
    
    var version: String?
    
    var bundleId: String?
    
    public required init?(map: Map) { }
    
    public func mapping(map: Map) {
        trackViewUrl <- map["trackViewUrl"]
        releaseNotes <- map["releaseNotes"]
        trackId      <- map["trackId"]
        trackName    <- map["trackName"]
        version      <- map["version"]
        bundleId     <- map["bundleId"]
    }
}
