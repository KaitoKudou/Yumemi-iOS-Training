//
//  WeatherViewTests.swift
//  Yumemi-ios-trainingTests
//
//  Created by 工藤 海斗 on 2022/04/06.
//

import XCTest
@testable import Yumemi_ios_training

class WeatherViewTests: XCTestCase {

    var model: WeatherListFetcher!
    private let weatherViewController = R.storyboard.main.weatherViewController()
    private let weatherTableViewCell = Bundle(for: WeatherTableViewCell.self).loadNibNamed(R.nib.weatherTableViewCell.name, owner: nil)?.first as! WeatherTableViewCell
    
    override func setUpWithError() throws {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        windowScenes?.keyWindow?.rootViewController = weatherViewController
        model = WeatherListFetcher()
    }

    override func tearDownWithError() throws {
    }
    
    @MainActor func testShowInvalidParameterErrorAlert() {
        weatherViewController?.showErrorAlert(with: R.string.message.invalidParameterError())
        XCTAssertTrue(weatherViewController?.presentedViewController is UIAlertController)
        XCTAssertEqual(weatherViewController?.presentedViewController?.title, R.string.message.alertControllerTitle())
        XCTAssertEqual((weatherViewController?.presentedViewController as? UIAlertController)?.message, R.string.message.invalidParameterError())
    }
    
    @MainActor func testShowUnknownErrorAlert() {
        weatherViewController?.showErrorAlert(with: R.string.message.unknownError())
        XCTAssertTrue(weatherViewController?.presentedViewController is UIAlertController)
        XCTAssertEqual(weatherViewController?.presentedViewController?.title, R.string.message.alertControllerTitle())
        XCTAssertEqual((weatherViewController?.presentedViewController as? UIAlertController)?.message, R.string.message.unknownError())
    }
    
    @MainActor func testShowSunnyImageWhenResponseIsSunny() {
        weatherTableViewCell.configure(weatherListResponse: WeatherListResponse(info: WeatherResponse(weather: .sunny, maxTemp: 0, minTemp: 0, date: Date()), area: "Tokyo"))
        XCTAssertNotNil(weatherTableViewCell.weatherImageView)
        XCTAssertEqual(weatherTableViewCell.weatherImageView.image, R.image.sunny())
    }
    
    @MainActor func testShowCloudyImageWhenResponseIsCloudy() {
        weatherTableViewCell.configure(weatherListResponse: WeatherListResponse(info: WeatherResponse(weather: .cloudy, maxTemp: 0, minTemp: 0, date: Date()), area: "Tokyo"))
        XCTAssertNotNil(weatherTableViewCell.weatherImageView)
        XCTAssertEqual(weatherTableViewCell.weatherImageView.image, R.image.cloudy())
    }
    
    @MainActor func testShowRainyImageWhenResponseIsRainy() {
        weatherTableViewCell.configure(weatherListResponse: WeatherListResponse(info: WeatherResponse(weather: .rainy, maxTemp: 0, minTemp: 0, date: Date()), area: "Tokyo"))
        XCTAssertNotNil(weatherTableViewCell.weatherImageView)
        XCTAssertEqual(weatherTableViewCell.weatherImageView.image, R.image.rainy())
    }
    
    @MainActor func testShowTemperatureLabel() {
        weatherTableViewCell.configure(weatherListResponse: WeatherListResponse(info: WeatherResponse(weather: .rainy, maxTemp: 10, minTemp: 5, date: Date()), area: "Tokyo"))
        XCTAssertEqual(weatherTableViewCell.minTemperatureLabel.text, "5")
        XCTAssertEqual(weatherTableViewCell.maxTemperatureLabel.text, "10")
    }
    
    func testResponseUnknownError() async {
        model.jsonDecoder.dateDecodingStrategy = .secondsSince1970 // iso8601以外を指定
        switch await model.fetchWeather(areas: ["Tokyo"], date: Date()) {
        case .success(_):
            XCTFail("\(#function) fail")
        case .failure(let error):
            XCTAssertEqual(error, APIError.unknownError)
            XCTAssertEqual(error.errorDescription, R.string.message.unknownError())
        }
    }
    
    func testResponseInvalidParameterError() async {
        model.jsonEncoder.dateEncodingStrategy = .secondsSince1970 // iso8601以外を指定
        switch await model.fetchWeather(areas: ["Tokyo"], date: Date()) {
        case .success(_):
            XCTFail("\(#function) fail")
        case .failure(let error):
            XCTAssertEqual(error, APIError.invalidParameterError)
            XCTAssertEqual(error.errorDescription, R.string.message.invalidParameterError())
        }
    }
}
