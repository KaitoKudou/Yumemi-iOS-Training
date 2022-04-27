//
//  WeatherListResponse.swift
//  Yumemi-ios-training
//
//  Created by 工藤 海斗 on 2022/04/27.
//

import Foundation

struct WeatherListResponse: Codable {
    let info: WeatherResponse
    let area: String
}
