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
    case store
}

public enum DetectType {
    case immediate
    case never
    case interval(Float)
}
