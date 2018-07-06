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
    
    var resultCount: String?
    
    var results: [AppInfoResults]?
    
    public required init?(map: Map) { }
    
    public func mapping(map: Map) {
        resultCount <- map["resultCount"]
        results <- map["results"]
    }
}


public class AppInfoResults: Mappable {
    
    public required init?(map: Map) { }
    
    public func mapping(map: Map) {
        
    }
}