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
    let date: String
    
    private enum CodingKeys: String, CodingKey {
        case weather
        case maxTemp = "max_temp"
        case minTemp = "min_temp"
        case date
    }
}
