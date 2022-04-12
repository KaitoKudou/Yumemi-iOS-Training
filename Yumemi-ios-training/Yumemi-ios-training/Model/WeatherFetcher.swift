//
//  WeatherFetcher.swift
//  Yumemi-ios-training
//
//  Created by 工藤 海斗 on 2022/03/28.
//

import Foundation
import YumemiWeather

protocol WeatherFetchable {
    func fetchWeather(completion: @escaping(Result<WeatherResponse, APIError>) -> Void)
}

class WeatherFetcher: WeatherFetchable {
    let jsonEncoder: JSONEncoder
    let jsonDecoder: JSONDecoder
    
    init() {
        jsonEncoder = JSONEncoder()
        jsonDecoder = JSONDecoder()
        jsonEncoder.dateEncodingStrategy = .iso8601
        jsonDecoder.dateDecodingStrategy = .iso8601
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func fetchWeather(completion: @escaping(Result<WeatherResponse, APIError>) -> Void) {
        do {
            let jsonData = try self.jsonEncoder.encode(WeatherRequest(area: "tokyo", date: Date()))
            guard let jsonString = String(data: jsonData, encoding: .utf8) else {  completion(.failure(APIError.invalidParameterError))
                return
            }
            let weatherJSONString = try YumemiWeather.syncFetchWeather(jsonString)
            completion(.success(try self.jsonDecoder.decode(WeatherResponse.self, from: Data(weatherJSONString.utf8))))
        } catch let error as YumemiWeatherError {
            completion(.failure(APIError(error: error)))
        } catch {
            completion(.failure(APIError.unknownError))
        }
    }
}
