//
//  WeatherFetcher.swift
//  Yumemi-ios-training
//
//  Created by 工藤 海斗 on 2022/03/28.
//

import Foundation
import YumemiWeather

protocol WeatherFetchable {
    func fetchWeaher() -> Result<WeatherResponse, APIError>
}

class WeatherFetcher: WeatherFetchable {
    func fetchWeaher() -> Result<WeatherResponse, APIError> {
        do {
            let jsonString = try YumemiWeather.fetchWeather(#"{"area": "tokyo", "date": "2020-04-01T12:00:00+09:00" }"#)
            let model = try parseJson(with: jsonString)
            return .success(model)
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
    
    func parseJson(with jsonString: String) throws -> WeatherResponse {
        guard let data = jsonString.data(using: .utf8) else { throw APIError.jsonParseError }
        let weaherData = try JSONDecoder().decode(WeatherResponse.self, from: data)
        return weaherData
    }
}
