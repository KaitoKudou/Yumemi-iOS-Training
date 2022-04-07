//
//  JsonParserTests.swift
//  Yumemi-ios-trainingTests
//
//  Created by 工藤 海斗 on 2022/04/07.
//

import XCTest
@testable import Yumemi_ios_training

class JsonParserTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
    func testJSONEncode() throws {
        let expectedResult = """
            {"date":"2020-04-01T03:00:00Z","area":"tokyo"}
            """
        let isoDateFormatter = ISO8601DateFormatter()
        let date = isoDateFormatter.date(from: "2020-04-01T12:00:00+09:00") ?? Date()
        let jsonEncoder = WeatherFetcher().jsonEncoder
        let jsonData = try jsonEncoder.encode(WeatherRequest(area: "tokyo", date: date))
        let jsonString = String(data: jsonData, encoding: .utf8)!
        XCTAssertEqual(jsonString, expectedResult)
    }
    
    func testJSONDecode() throws {
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        let date = isoDateFormatter.date(from: "2020-04-01T12:00:00+09:00") ?? Date()
        let expectedResult = WeatherResponse(weather: .sunny, maxTemp: 10, minTemp: 5, date: date)
        let jsonDecoder = WeatherFetcher().jsonDecoder
        let jsonDataString = """
            {"max_temp":10,"date":"2020-04-01T12:00:00+09:00","min_temp":5,"weather":"sunny"}
        """
        let data = jsonDataString.data(using: .utf8)!
        let weatherResponse = try jsonDecoder.decode(WeatherResponse.self, from: data)
        XCTAssertEqual(weatherResponse.maxTemp, expectedResult.maxTemp)
        XCTAssertEqual(weatherResponse.minTemp, expectedResult.minTemp)
        XCTAssertEqual(weatherResponse.date, expectedResult.date)
        XCTAssertEqual(weatherResponse.weather, expectedResult.weather)
    }
}
