//
//  APIError.swift
//  Yumemi-ios-training
//
//  Created by 工藤 海斗 on 2022/03/24.
//

import Foundation
import YumemiWeather

enum APIError: Error {
    case invalidParameterError
    case unknownError
    
    init(error: YumemiWeatherError) {
        switch error {
        case .invalidParameterError:
            self = .invalidParameterError
        case .unknownError:
            self = .unknownError
        }
    }
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidParameterError:
            return "パラメータが無効"
        case .unknownError:
            return "予期せぬエラーが発生"
        }
    }
}
