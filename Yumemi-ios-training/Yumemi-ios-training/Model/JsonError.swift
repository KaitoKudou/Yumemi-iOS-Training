//
//  JsonError.swift
//  Yumemi-ios-training
//
//  Created by 工藤 海斗 on 2022/03/31.
//

import Foundation

enum JsonError: Error {
    case jsonDecodeError
    case jsonEncodeError
    
    init(error: Self) {
        switch error {
        case .jsonDecodeError:
            self = .jsonDecodeError
        case .jsonEncodeError:
            self = .jsonEncodeError
        }
    }
}

extension JsonError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .jsonDecodeError:
            return "JSONのデコードに失敗"
        case .jsonEncodeError:
            return "JSONのエンコードに失敗"
        }
    }
}
