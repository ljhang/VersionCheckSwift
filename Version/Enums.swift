//
//  Enums.swift
//  Version
//
//  Created by 李建航 on 2018/7/9.
//  Copyright © 2018 lee. All rights reserved.
//

import Foundation

public enum ViewAppType: Int {
    case inApp
    case safari
}

public enum DetectType {
    case immediate
    case never
    case skip(String)
    case time(Float)
    
    /// 是否发起检测请求
    func isStartDetectApp() {
        
    }
}
