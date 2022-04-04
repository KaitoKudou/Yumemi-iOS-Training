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
}

extension JsonError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .jsonDecodeError:
            return R.string.message.jsonDecodeError()
        case .jsonEncodeError:
            return R.string.message.jsonEncodeError()
        }
    }
}
