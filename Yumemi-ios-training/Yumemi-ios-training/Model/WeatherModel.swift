//
//  WeatherModel.swift
//  Yumemi-ios-training
//
//  Created by 工藤 海斗 on 2022/03/24.
//

import Foundation
import YumemiWeather

protocol WeatherModelProtocol {
    func fetchWeather() -> String
}

class WeatherModel: WeatherModelProtocol {
    func fetchWeather() -> String {
        return YumemiWeather.fetchWeather()
    }
}
