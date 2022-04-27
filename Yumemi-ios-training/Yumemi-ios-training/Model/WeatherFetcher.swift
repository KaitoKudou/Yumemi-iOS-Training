//
//  WeatherFetcher.swift
//  Yumemi-ios-training
//
//  Created by 工藤 海斗 on 2022/03/28.
//

import Foundation
import YumemiWeather

protocol WeatherFetchable {
    func fetchWeather() async -> Result<[WeatherListResponse], APIError>
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
    
    func fetchWeather() async -> Result<[WeatherListResponse], APIError> {
        do {
            let jsonListData = try self.jsonEncoder.encode(WeatherListRequest(areas: ["Sapporo", "Sendai", "Tokyo"], date: Date()))
            guard let jsonListString = String(data: jsonListData, encoding: .utf8) else {
                return .failure(APIError.invalidParameterError)
            }
            let weatherJSONListString = try await YumemiWeather.asyncFetchWeatherList(jsonListString)
            return .success(try self.jsonDecoder.decode([WeatherListResponse].self, from: Data(weatherJSONListString.utf8)))
        } catch let error as YumemiWeatherError {
            return .failure(APIError(error: error))
        } catch {
            return .failure(APIError.unknownError)
        }
    }
}
