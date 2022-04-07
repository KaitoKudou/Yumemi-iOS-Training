//
//  JsonParserTests.swift
//  Yumemi-ios-trainingTests
//
//  Created by 工藤 海斗 on 2022/04/07.
//

import XCTest
@testable import Yumemi_ios_training

class JsonParserMock: JsonParseable {
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

class JsonParserTests: XCTestCase {
    var mock: JsonParserMock!

    override func setUpWithError() throws {
        mock = JsonParserMock()
    }

    override func tearDownWithError() throws {
    }
    
    func testSuccessEncodeJson() throws {
        let isoDateFormatter = ISO8601DateFormatter()
        let date = isoDateFormatter.date(from: "2020-04-01T12:00:00+09:00") ?? Date()
        let expectedResult = """
            {"date":"2020-04-01T03:00:00Z","area":"tokyo"}
            """
        let result = try mock.encodeJson(request: WeatherRequest(area: "tokyo", date: date))
        XCTAssertEqual(result, expectedResult)
    }
    
    func testSuccessDecodeJson() throws {
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        let date = isoDateFormatter.date(from: "2020-04-01T12:00:00+09:00") ?? Date()
        let expectedResult = WeatherResponse(weather: .sunny, maxTemp: 10, minTemp: 5, date: date)
        let jsonString = """
                {"max_temp":10,"date":"2020-04-01T12:00:00+09:00","min_temp":5,"weather":"sunny"}
            """
        let result = try mock.decodeJson(with: jsonString)
        XCTAssertEqual(result.maxTemp, expectedResult.maxTemp)
        XCTAssertEqual(result.minTemp, expectedResult.minTemp)
        XCTAssertEqual(result.date, expectedResult.date)
        XCTAssertEqual(result.weather, expectedResult.weather)
    }
}
