//
//  WeatherModel.swift
//  Yumemi-ios-training
//
//  Created by 工藤 海斗 on 2022/03/24.
//

import Foundation
import YumemiWeather

protocol WeatherModelProtocol {
    func feachWeaher() -> Result<WeatherType, APIError>
}

class WeatherModel: WeatherModelProtocol {
    func feachWeaher() -> Result<WeatherType, APIError> {
        do {
            let weatherString = try YumemiWeather.fetchWeather(at: "tokyo")
            return .success(WeatherType(rawValue: weatherString)!)
        } catch let error as YumemiWeatherError {
            switch error {
            case .invalidParameterError:
                return .failure(.invalidParameterError)
            case .unknownError:
                return .failure(.unknownError)
            }
        } catch {
            fatalError("天気情報取得時に予期せぬエラーが発生：\(error.localizedDescription)")
        }
    }
}
