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
        let today: String = {
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.timeZone = TimeZone.current
            return isoFormatter.string(from: Date())
        }()
        
        do {
            let request = try JSONEncoder().encode(WeatherRequest(area: "tokyo", date: today))
            guard let jsonString = String(data: request, encoding: .utf8) else { fatalError("リクエストのエンコードに失敗") }
            print(jsonString)
            let weatherData = try YumemiWeather.fetchWeather(jsonString)
            let model = try parseJson(with: weatherData)
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
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let weaherData = try decoder.decode(WeatherResponse.self, from: data)
        return weaherData
    }
}
