//
//  WeatherFetcher.swift
//  Yumemi-ios-training
//
//  Created by 工藤 海斗 on 2022/03/28.
//

import Foundation
import YumemiWeather

protocol WeatherFetchable {
    func fetchWeather() -> Result<WeatherResponse, APIError>
}

protocol JsonParseable {
    func encodeJson(request: WeatherRequest) throws -> String
    func decodeJson(with jsonString: String) throws -> WeatherResponse
}

class WeatherFetcher: WeatherFetchable {
    func fetchWeather() -> Result<WeatherResponse, APIError> {
        do {
            let jsonString = try encodeJson(request: WeatherRequest(area: "tokyo", date: Date()))
            let weatherData = try YumemiWeather.fetchWeather(jsonString)
            print(weatherData)
            let model = try decodeJson(with: weatherData)
            return .success(model)
        } catch let error as YumemiWeatherError {
            return .failure(APIError(error: error))
        } catch let error as APIError {
            return .failure(error)
        } catch {
            fatalError("天気情報取得時に予期せぬエラーが発生：\(error.localizedDescription)")
        }
    }
}

extension WeatherFetcher: JsonParseable {
    func encodeJson(request: WeatherRequest) throws -> String {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            let request = try encoder.encode(request)
            guard let jsonString = String(data: request, encoding: .utf8) else { throw APIError.invalidParameterError }
            return jsonString
        } catch  {
            throw APIError.invalidParameterError
        }
    }
    
    func decodeJson(with jsonString: String) throws -> WeatherResponse {
        guard let data = jsonString.data(using: .utf8) else { throw APIError.unknownError }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let weaherData = try decoder.decode(WeatherResponse.self, from: data)
            return weaherData
        } catch {
            throw APIError.unknownError
        }
    }
}
