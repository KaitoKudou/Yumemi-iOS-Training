//
//  WeatherListRequest.swift
//  Yumemi-ios-training
//
//  Created by 工藤 海斗 on 2022/04/27.
//

import Foundation

struct WeatherListRequest: Encodable {
    let areas: [String]
    let date: Date
}
