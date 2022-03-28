//
//  WeatherFetcher.swift
//  Yumemi-ios-training
//
//  Created by 工藤 海斗 on 2022/03/28.
//

import Foundation
import YumemiWeather

protocol WeatherFetchable {
    func fechWeaher() -> Result<WeatherType, APIError>
}

class WeatherFetcher: WeatherFetchable {
    func fechWeaher() -> Result<WeatherType, APIError> {
        do {
            let weatherString = try YumemiWeather.fetchWeather(at: "tokyo")
            guard let weather = WeatherType(rawValue: weatherString) else {
                fatalError("天気情報の文字列のinitに失敗")
            }
            return .success(weather)
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
