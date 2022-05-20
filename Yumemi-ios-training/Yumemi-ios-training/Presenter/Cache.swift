//
//  Cache.swift
//  Yumemi-ios-training
//
//  Created by 工藤 海斗 on 2022/05/18.
//

import Foundation

final class Cache: NSCache<AnyObject, AnyObject> {

    static let shared = Cache()
    
    private override init() {
    }
}
