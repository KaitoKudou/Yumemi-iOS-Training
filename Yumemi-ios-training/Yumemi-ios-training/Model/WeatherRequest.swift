//
//  WeatherRequest.swift
//  Yumemi-ios-training
//
//  Created by 工藤 海斗 on 2022/03/31.
//

import Foundation

struct WeatherRequest: Encodable {
    let area: String
    let date: Date
}
