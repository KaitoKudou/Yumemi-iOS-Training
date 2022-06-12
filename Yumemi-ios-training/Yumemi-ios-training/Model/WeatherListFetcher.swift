//
//  WeatherListFetcher.swift
//  Yumemi-ios-training
//
//  Created by 工藤 海斗 on 2022/05/12.
//

import Foundation
import YumemiWeather

protocol WeatherListFetchable {
    func fetchWeather(areas: [String], date: Date) async -> Result<[WeatherListResponse], APIError>
}

class WeatherListFetcher: WeatherListFetchable {
    let jsonEncoder: JSONEncoder
    let jsonDecoder: JSONDecoder
    
    init() {
        jsonEncoder = JSONEncoder()
        jsonDecoder = JSONDecoder()
        jsonEncoder.dateEncodingStrategy = .iso8601
        jsonDecoder.dateDecodingStrategy = .iso8601
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func fetchWeather(areas: [String], date: Date) async -> Result<[WeatherListResponse], APIError> {
        do {
            let jsonListData = try self.jsonEncoder.encode(WeatherListRequest(areas: areas, date: date))
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
