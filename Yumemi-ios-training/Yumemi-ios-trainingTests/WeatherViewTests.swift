//
//  WeatherViewTests.swift
//  Yumemi-ios-trainingTests
//
//  Created by 工藤 海斗 on 2022/04/06.
//

import XCTest
@testable import Yumemi_ios_training

class WeatherViewTests: XCTestCase {

    var model: WeatherFetcher!
    private let viewController = R.storyboard.main.weatherViewController()
    
    override func setUpWithError() throws {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        windowScenes?.keyWindow?.rootViewController = viewController
        model = WeatherFetcher()
    }

    override func tearDownWithError() throws {
    }
    
    func testCallFetchWeather() {
        viewController?.reloadButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(viewController?.activityIndicatorView.isAnimating, true) // インジケータが表示されるとpresenter.fetchWeather()が呼ばれていることがわかる
    }
    
    @MainActor func testShowInvalidParameterErrorAlert() {
        viewController?.showErrorAlert(with: R.string.message.invalidParameterError())
        XCTAssertTrue(viewController?.presentedViewController is UIAlertController)
        XCTAssertEqual(viewController?.presentedViewController?.title, R.string.message.alertControllerTitle())
        XCTAssertEqual(viewController?.activityIndicatorView.isAnimating, false)
        XCTAssertEqual((viewController?.presentedViewController as? UIAlertController)?.message, R.string.message.invalidParameterError())
    }
    
    @MainActor func testShowUnknownErrorAlert() {
        viewController?.showErrorAlert(with: R.string.message.unknownError())
        XCTAssertTrue(viewController?.presentedViewController is UIAlertController)
        XCTAssertEqual(viewController?.presentedViewController?.title, R.string.message.alertControllerTitle())
        XCTAssertEqual(viewController?.activityIndicatorView.isAnimating, false)
        XCTAssertEqual((viewController?.presentedViewController as? UIAlertController)?.message, R.string.message.unknownError())
    }
    
    @MainActor func testShowSunnyImageWhenResponseIsSunny() {
        viewController?.showWeather(weatherResponse: WeatherResponse(weather: .sunny, maxTemp: 0, minTemp: 0, date: Date()))
        XCTAssertNotNil(viewController?.weatherImageView)
        XCTAssertEqual(viewController?.weatherImageView.image, R.image.sunny())
        XCTAssertEqual(viewController?.activityIndicatorView.isAnimating, false)
    }
    
    @MainActor func testShowCloudyImageWhenResponseIsCloudy() {
        viewController?.showWeather(weatherResponse: WeatherResponse(weather: .cloudy, maxTemp: 0, minTemp: 0, date: Date()))
        XCTAssertNotNil(viewController?.weatherImageView)
        XCTAssertEqual(viewController?.weatherImageView.image, R.image.cloudy())
        XCTAssertEqual(viewController?.activityIndicatorView.isAnimating, false)
    }
    
    @MainActor func testShowRainyImageWhenResponseIsRainy() {
        viewController?.showWeather(weatherResponse: WeatherResponse(weather: .rainy, maxTemp: 0, minTemp: 0, date: Date()))
        XCTAssertNotNil(viewController?.weatherImageView)
        XCTAssertEqual(viewController?.weatherImageView.image, R.image.rainy())
        XCTAssertEqual(viewController?.activityIndicatorView.isAnimating, false)
    }
    
    @MainActor func testShowTemperatureLabel() {
        viewController?.showWeather(weatherResponse: WeatherResponse(weather: .sunny, maxTemp: 10, minTemp: 5, date: Date()))
        XCTAssertNotNil(viewController?.maxTemperatureLabel)
        XCTAssertNotNil(viewController?.minTemperatureLabel)
        XCTAssertEqual(viewController?.maxTemperatureLabel.text, "10")
        XCTAssertEqual(viewController?.minTemperatureLabel.text, "5")
        XCTAssertEqual(viewController?.activityIndicatorView.isAnimating, false)
    }
    
    func testResponseUnknownError() async {
        model.jsonDecoder.dateDecodingStrategy = .secondsSince1970 // iso8601以外を指定
        switch await model.fetchWeather() {
        case .success(_):
            XCTFail("\(#function) fail")
        case .failure(let error):
            XCTAssertEqual(error, APIError.unknownError)
            XCTAssertEqual(error.errorDescription, R.string.message.unknownError())
        }
    }
    
    func testResponseInvalidParameterError() async {
        model.jsonEncoder.dateEncodingStrategy = .secondsSince1970 // iso8601以外を指定
        switch await model.fetchWeather() {
        case .success(_):
            XCTFail("\(#function) fail")
        case .failure(let error):
            XCTAssertEqual(error, APIError.invalidParameterError)
            XCTAssertEqual(error.errorDescription, R.string.message.invalidParameterError())
        }
    }
}
