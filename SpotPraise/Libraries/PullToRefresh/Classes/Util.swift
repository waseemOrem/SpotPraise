//
//  RefreshUtil.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/12.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit

struct PullToRefreshKitConst{
    //KVO
    static let KPathOffSet = "contentOffset"
    static let KPathPanState = "state"
    static let KPathContentSize = "contentSize"
    
    //Default const
    static let defaultHeaderHeight: CGFloat = 80.0
    static let defaultFooterHeight: CGFloat = 44.0
    static let defaultLeftWidth: CGFloat    = 50.0
    static let defaultRightWidth: CGFloat   = 50.0
    
    //Tags
    static let headerTag = 100001
    static let footerTag = 100002
    static let leftTag   = 100003
    static let rightTag  = 100004
}

func PTRLocalize(_ string:String)->String{
    return NSLocalizedString(string, tableName: "Localize", bundle: Bundle(for: DefaultRefreshHeader.self), value: "", comment: "")
}

struct PullToRefreshKitHeaderString{
    static let pullDownToRefresh = PTRLocalize("")
    static let releaseToRefresh = PTRLocalize("")
    static let refreshSuccess = PTRLocalize("")
    static let refreshFailure = PTRLocalize("")
    static let refreshing = PTRLocalize("")
}

struct PullToRefreshKitFooterString{
    static let pullUpToRefresh = PTRLocalize("")
    static let refreshing = PTRLocalize("")
    static let noMoreData = PTRLocalize("")
    static let tapToRefresh = PTRLocalize("")
    static let scrollAndTapToRefresh = PTRLocalize("")
}

struct PullToRefreshKitLeftString{
    static let scrollToClose = ""
    static let releaseToClose = ""
}

struct PullToRefreshKitRightString{
    static let scrollToViewMore = ""
    static let releaseToViewMore = ""
}
