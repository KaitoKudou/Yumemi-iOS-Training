//
//  WeatherResponse.swift
//  Yumemi-ios-training
//
//  Created by 工藤 海斗 on 2022/03/24.
//

import Foundation

struct WeatherResponse: Codable {
    let weather: WeatherType
    let maxTemp: Int
    let minTemp: Int
    let date: Date
}
