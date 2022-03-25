//
//  WeatherModel.swift
//  Yumemi-ios-training
//
//  Created by 工藤 海斗 on 2022/03/24.
//

import Foundation
import YumemiWeather

protocol WeatherModelProtocol {
    func fetchWeather(completion: @escaping (WeatherType) -> Void)
}

class WeatherModel: WeatherModelProtocol {
    func fetchWeather(completion: @escaping (WeatherType) -> Void) {
        completion(WeatherType(rawValue: YumemiWeather.fetchWeather())!)
    }
}
