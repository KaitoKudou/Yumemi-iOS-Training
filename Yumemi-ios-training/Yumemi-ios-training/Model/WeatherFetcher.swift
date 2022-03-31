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
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            return formatter
        }()
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .formatted(dateFormatter)
            let request = try encoder.encode(WeatherRequest(area: "tokyo", date: Date()))
            guard let jsonString = String(data: request, encoding: .utf8) else { return .failure(.jsonEncodeError) }
            let weatherData = try YumemiWeather.fetchWeather(jsonString)
            guard let model = parseJson(with: weatherData) else { return .failure(.jsonDecodeError) }
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
    
    func parseJson(with jsonString: String) -> WeatherResponse? {
        guard let data = jsonString.data(using: .utf8) else { return nil }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let weaherData = try decoder.decode(WeatherResponse.self, from: data)
            return weaherData
        } catch {
            return nil
        }
    }
}
