//
//  WeatherViewTests.swift
//  Yumemi-ios-trainingTests
//
//  Created by 工藤 海斗 on 2022/04/06.
//

import XCTest
@testable import Yumemi_ios_training

class WeatherPresenterSpy: WeatherPresenterProtocolOutput {
    func showWeather(weatherResponse: WeatherResponse) {
    }
    
    func showErrorAlert(with message: String?) {
    }
    
    func startIndicatorAnimating() {
    }
    
    func stopIndicatorAnimating() {
    }
}

class WeatherFetcherStub: WeatherFetchable {
    private let result: Result<WeatherResponse, APIError>
    
    init(result: Result<WeatherResponse, APIError>) {
        self.result = result
    }
    
    func fetchWeather(completion: @escaping (Result<WeatherResponse, APIError>) -> Void) {
        completion(result)
    }
}

class WeatherViewTests: XCTestCase {

    var spy: WeatherPresenterSpy!
    var presenter: WeatherPresenter!
    private let viewController = R.storyboard.main.weatherViewController()
    
    override func setUpWithError() throws {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        windowScenes?.keyWindow?.rootViewController = viewController
        spy = WeatherPresenterSpy()
    }

    override func tearDownWithError() throws {
    }
    
    func testCallFetchWeather() {
        viewController?.reloadButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(viewController?.activityIndicatorView.isAnimating, true) // インジケータが表示されるとpresenter.fetchWeather()が呼ばれていることがわかる
    }
    
    func testShowInvalidParameterErrorAlert() {
        viewController?.showErrorAlert(with: R.string.message.invalidParameterError())
        XCTAssertTrue(viewController?.presentedViewController is UIAlertController)
        XCTAssertEqual(viewController?.presentedViewController?.title, R.string.message.alertControllerTitle())
        XCTAssertEqual(viewController?.activityIndicatorView.isAnimating, false)
        XCTAssertEqual((viewController?.presentedViewController as? UIAlertController)?.message, R.string.message.invalidParameterError())
    }
    
    func testShowUnknownErrorAlert() {
        viewController?.showErrorAlert(with: R.string.message.unknownError())
        XCTAssertTrue(viewController?.presentedViewController is UIAlertController)
        XCTAssertEqual(viewController?.presentedViewController?.title, R.string.message.alertControllerTitle())
        XCTAssertEqual(viewController?.activityIndicatorView.isAnimating, false)
        XCTAssertEqual((viewController?.presentedViewController as? UIAlertController)?.message, R.string.message.unknownError())
    }
    
    func testShowSunnyImageWhenResponseIsSunny() {
        viewController?.showWeather(weatherResponse: WeatherResponse(weather: .sunny, maxTemp: 0, minTemp: 0, date: Date()))
        XCTAssertNotNil(viewController?.weatherImageView)
        XCTAssertEqual(viewController?.weatherImageView.image, R.image.sunny())
        XCTAssertEqual(viewController?.activityIndicatorView.isAnimating, false)
    }
    
    func testShowCloudyImageWhenResponseIsCloudy() {
        viewController?.showWeather(weatherResponse: WeatherResponse(weather: .cloudy, maxTemp: 0, minTemp: 0, date: Date()))
        XCTAssertNotNil(viewController?.weatherImageView)
        XCTAssertEqual(viewController?.weatherImageView.image, R.image.cloudy())
        XCTAssertEqual(viewController?.activityIndicatorView.isAnimating, false)
    }
    
    func testShowRainyImageWhenResponseIsRainy() {
        viewController?.showWeather(weatherResponse: WeatherResponse(weather: .rainy, maxTemp: 0, minTemp: 0, date: Date()))
        XCTAssertNotNil(viewController?.weatherImageView)
        XCTAssertEqual(viewController?.weatherImageView.image, R.image.rainy())
        XCTAssertEqual(viewController?.activityIndicatorView.isAnimating, false)
    }
    
    func testShowTemperatureLabel() {
        viewController?.showWeather(weatherResponse: WeatherResponse(weather: .sunny, maxTemp: 10, minTemp: 5, date: Date()))
        XCTAssertNotNil(viewController?.maxTemperatureLabel)
        XCTAssertNotNil(viewController?.minTemperatureLabel)
        XCTAssertEqual(viewController?.maxTemperatureLabel.text, "10")
        XCTAssertEqual(viewController?.minTemperatureLabel.text, "5")
        XCTAssertEqual(viewController?.activityIndicatorView.isAnimating, false)
    }
    
    func testResponseUnknownError() {
        let stub = WeatherFetcherStub(result: .failure(.unknownError))
        stub.fetchWeather(completion: { result in
            switch result {
            case .success(_):
                return
            case .failure(let error):
                XCTAssertEqual(error.errorDescription, R.string.message.unknownError())
            }
        })
    }
    
    func testResponseInvalidParameterError() {
        let stub = WeatherFetcherStub(result: .failure(.invalidParameterError))
        stub.fetchWeather(completion: { result in
            switch result {
            case .success(_):
                return
            case .failure(let error):
                XCTAssertEqual(error.errorDescription, R.string.message.invalidParameterError())
            }
        })
    }
}
