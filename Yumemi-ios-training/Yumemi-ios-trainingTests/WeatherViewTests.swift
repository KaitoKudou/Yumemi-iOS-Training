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
    
    func fetchWeather() -> Result<WeatherResponse, APIError> {
        return result
    }
}

class WeatherViewTests: XCTestCase {

    var spy: WeatherPresenterSpy!
    var presenter: WeatherPresenter!
    private let viewController = R.storyboard.main.weatherViewController()
    
    override func setUpWithError() throws {
        spy = WeatherPresenterSpy()
        _ = viewController?.view
    }

    override func tearDownWithError() throws {
    }
    
    func testShowSunnyImageWhenResponseIsSunny() {
        let stub = WeatherFetcherStub(result: .success(WeatherResponse(weather: .sunny, maxTemp: 0, minTemp: 0, date: Date())))
        presenter = WeatherPresenter(view: spy, model: stub)
        presenter.view = spy
        
        switch stub.fetchWeather() {
        case .success(let weather):
            spy.showWeather(weatherResponse: weather)
            viewController?.weatherImageView.image = R.image.sunny()
            XCTAssertNotNil(viewController?.weatherImageView)
            XCTAssertEqual(viewController?.weatherImageView.image, R.image.sunny())
        case .failure(_):
            return
        }
    }
    
    func testShowCloudyImageWhenResponseIsCloudy() {
        let stub = WeatherFetcherStub(result: .success(WeatherResponse(weather: .cloudy, maxTemp: 0, minTemp: 0, date: Date())))
        presenter = WeatherPresenter(view: spy, model: stub)
        presenter.view = spy
        
        switch stub.fetchWeather() {
        case .success(let weather):
            spy.showWeather(weatherResponse: weather)
            viewController?.weatherImageView.image = R.image.cloudy()
            XCTAssertNotNil(viewController?.weatherImageView)
            XCTAssertEqual(viewController?.weatherImageView.image, R.image.cloudy())
        case .failure(_):
            return
        }
    }
    
    func testShowRainyImageWhenResponseIsRainy() {
        let stub = WeatherFetcherStub(result: .success(WeatherResponse(weather: .rainy, maxTemp: 0, minTemp: 0, date: Date())))
        presenter = WeatherPresenter(view: spy, model: stub)
        presenter.view = spy
        
        switch stub.fetchWeather() {
        case .success(let weather):
            spy.showWeather(weatherResponse: weather)
            viewController?.weatherImageView.image = R.image.rainy()
            XCTAssertNotNil(viewController?.weatherImageView)
            XCTAssertEqual(viewController?.weatherImageView.image, R.image.rainy())
        case .failure(_):
            return
        }
    }
    
    func testShowTemperatureLabel() {
        let stub = WeatherFetcherStub(result: .success(WeatherResponse(weather: .sunny, maxTemp: 10, minTemp: 5, date: Date())))
        presenter = WeatherPresenter(view: spy, model: stub)
        presenter.view = spy
        
        switch stub.fetchWeather() {
        case .success(let weather):
            spy.showWeather(weatherResponse: weather)
            viewController?.maxTemperatureLabel.text = String(weather.maxTemp)
            viewController?.minTemperatureLabel.text = String(weather.minTemp)
            XCTAssertNotNil(viewController?.maxTemperatureLabel)
            XCTAssertNotNil(viewController?.minTemperatureLabel)
            XCTAssertEqual(viewController?.maxTemperatureLabel.text, "10")
            XCTAssertEqual(viewController?.minTemperatureLabel.text, "5")
        case .failure(_):
            return
        }
    }
    
    func testResponseUnknownError() {
        let stub = WeatherFetcherStub(result: .failure(.unknownError))
        presenter = WeatherPresenter(view: spy, model: stub)
        presenter.view = spy
        
        switch stub.fetchWeather() {
        case .success(_):
            return
        case .failure(let error):
            XCTAssertEqual(error.errorDescription, "予期せぬエラーが発生")
        }
    }
    
    func testResponseInvalidParameterError() {
        let stub = WeatherFetcherStub(result: .failure(.invalidParameterError))
        presenter = WeatherPresenter(view: spy, model: stub)
        presenter.view = spy
        
        switch stub.fetchWeather() {
        case .success(_):
            return
        case .failure(let error):
            XCTAssertEqual(error.errorDescription, "パラメータが無効")
        }
    }
}
