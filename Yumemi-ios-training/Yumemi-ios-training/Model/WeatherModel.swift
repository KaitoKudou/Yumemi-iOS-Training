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
        // YumemiWeather.fetchWeather()は必ず何かしら文字列を返してくるが
        // Session3以降ではエラーを含むのでオプショナルで扱う
        completion(WeatherType(rawValue: YumemiWeather.fetchWeather())!)
    }
}
