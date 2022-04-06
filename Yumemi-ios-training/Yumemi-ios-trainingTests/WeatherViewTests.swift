//
//  WeatherViewTests.swift
//  Yumemi-ios-trainingTests
//
//  Created by 工藤 海斗 on 2022/04/06.
//

import XCTest
@testable import Yumemi_ios_training


class WeatherPresenterSpy: WeatherPresenterProtocolOutput {
    private let viewController = R.storyboard.main.weatherViewController()
    func showWeather(weatherResponse: WeatherResponse) {
    }
    
    func showErrorAlert(with message: String?) {
    }
}

class WeatherFetcherStub: WeatherFetchable {
    private var weatherType: WeatherType
    private var error: APIError?
    private var temperature: Int
    
    init(weatherType: WeatherType, temperature: Int) {
        self.weatherType = weatherType
        self.temperature = temperature
    }
    
    func fetchWeather() -> Result<WeatherResponse, APIError> {
        if let error = error {
            return .failure(error)
        }
        return .success(WeatherResponse(weather: weatherType, maxTemp: temperature, minTemp: temperature, date: Date()))
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
        let stub = WeatherFetcherStub(weatherType: .sunny, temperature: 0)
        presenter = WeatherPresenter(view: spy, model: stub)
        presenter.view = spy
        presenter.model = stub
        
        switch stub.fetchWeather() {
        case .success(let weather):
            spy.showWeather(weatherResponse: weather)
            viewController?.weatherImageView.image = R.image.sunny()
            XCTAssertNotNil(viewController?.weatherImageView)
            XCTAssertEqual(viewController?.weatherImageView.image, R.image.sunny())
            return
        case .failure(_):
            return
        }
    }
    
    func testShowCloudyImageWhenResponseIsCloudy() {
        let stub = WeatherFetcherStub(weatherType: .cloudy, temperature: 0)
        presenter = WeatherPresenter(view: spy, model: stub)
        presenter.view = spy
        presenter.model = stub
        
        switch stub.fetchWeather() {
        case .success(let weather):
            spy.showWeather(weatherResponse: weather)
            viewController?.weatherImageView.image = R.image.cloudy()
            XCTAssertNotNil(viewController?.weatherImageView)
            XCTAssertEqual(viewController?.weatherImageView.image, R.image.cloudy())
            return
        case .failure(_):
            return
        }
    }
    
    func testShowRainyImageWhenResponseIsRainy() {
        let stub = WeatherFetcherStub(weatherType: .rainy, temperature: 0)
        presenter = WeatherPresenter(view: spy, model: stub)
        presenter.view = spy
        presenter.model = stub
        
        switch stub.fetchWeather() {
        case .success(let weather):
            spy.showWeather(weatherResponse: weather)
            viewController?.weatherImageView.image = R.image.rainy()
            XCTAssertNotNil(viewController?.weatherImageView)
            XCTAssertEqual(viewController?.weatherImageView.image, R.image.rainy())
            return
        case .failure(_):
            return
        }
    }
    
    func testShowTemperatureLabel() {
        let stub = WeatherFetcherStub(weatherType: .sunny, temperature: 10)
        presenter = WeatherPresenter(view: spy, model: stub)
        presenter.view = spy
        presenter.model = stub
        
        switch stub.fetchWeather() {
        case .success(let weather):
            spy.showWeather(weatherResponse: weather)
            viewController?.maxTemperatureLabel.text = String(weather.maxTemp)
            viewController?.minTemperatureLabel.text = String(weather.minTemp)
            XCTAssertNotNil(viewController?.maxTemperatureLabel)
            XCTAssertNotNil(viewController?.minTemperatureLabel)
            XCTAssertEqual(viewController?.maxTemperatureLabel.text, "10")
            XCTAssertEqual(viewController?.minTemperatureLabel.text, "10")
            return
        case .failure(_):
            return
        }
    }
}
