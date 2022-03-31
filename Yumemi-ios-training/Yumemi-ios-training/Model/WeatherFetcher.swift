//
//  WeatherFetcher.swift
//  Yumemi-ios-training
//
//  Created by 工藤 海斗 on 2022/03/28.
//

import Foundation
import YumemiWeather

protocol WeatherFetchable {
    func fetchWeaher() -> Result<WeatherResponse, Error>
}

class WeatherFetcher: WeatherFetchable {
    func fetchWeaher() -> Result<WeatherResponse, Error> {
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            return formatter
        }()
        
        do {
            let jsonString = try encodeJson(request: WeatherRequest(area: "tokyo", date: Date()))
            let weatherData = try YumemiWeather.fetchWeather(jsonString)
            let model = try decodeJson(with: weatherData)
            return .success(model)
        } catch let error as YumemiWeatherError {
            return .failure(APIError(error: error))
        } catch let error as JsonError {
            return .failure(JsonError(error: error))
        } catch {
            fatalError("天気情報取得時に予期せぬエラーが発生：\(error.localizedDescription)")
        }
    }
    
    func encodeJson(request: WeatherRequest) throws -> String {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let request = try encoder.encode(request)
        guard let jsonString = String(data: request, encoding: .utf8) else { throw JsonError.jsonEncodeError }
        return jsonString
    }
    
    func decodeJson(with jsonString: String) throws -> WeatherResponse {
        guard let data = jsonString.data(using: .utf8) else { throw JsonError.jsonDecodeError }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let weaherData = try decoder.decode(WeatherResponse.self, from: data)
            return weaherData
        } catch {
            throw JsonError.jsonDecodeError
        }
    }
}
