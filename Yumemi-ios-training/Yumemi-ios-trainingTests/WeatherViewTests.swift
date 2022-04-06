//
//  WeatherViewTests.swift
//  Yumemi-ios-trainingTests
//
//  Created by 工藤 海斗 on 2022/04/06.
//

import XCTest
@testable import Yumemi_ios_training


class WeatherPresenterSpy: WeatherPresenterProtocolOutput {
    private(set) var weatherType: WeatherType!
    private let viewController = R.storyboard.main.weatherViewController()
    func showWeather(weatherResponse: WeatherResponse) {
        _ = viewController?.view
        switch weatherResponse.weather {
        case .sunny:
            weatherType = .sunny
            viewController?.weatherImageView.image = R.image.sunny()
            XCTAssertEqual(viewController?.weatherImageView.image, R.image.sunny())
        case .cloudy:
            weatherType = .cloudy
        case .rainy:
            weatherType = .rainy
        }
    }
    
    func showErrorAlert(with message: String?) {
    }
}

class WeatherFetcherStub: WeatherFetchable {
    private var weatherType: WeatherType!
    private var error: APIError?
    
    init(weatherType: WeatherType) {
        self.weatherType = weatherType
    }
    
    func fetchWeather() -> Result<WeatherResponse, APIError> {
        if let error = error {
            return .failure(error)
        }
        return .success(WeatherResponse(weather: weatherType, maxTemp: 0, minTemp: 0, date: Date()))
    }
}

class WeatherViewTests: XCTestCase {

    var spy: WeatherPresenterSpy!
    var presenter: WeatherPresenter!
    var viewController: WeatherViewController!
    
    override func setUpWithError() throws {
        spy = WeatherPresenterSpy()
    }

    override func tearDownWithError() throws {
    }
    
    func testResponseIsSunny() {
        let stub = WeatherFetcherStub(weatherType: .sunny)
        presenter = WeatherPresenter(view: spy, model: stub)
        presenter.view = spy
        presenter.model = stub
        
        switch stub.fetchWeather() {
        case .success(let weather):
            spy.showWeather(weatherResponse: weather)
            return
        case .failure(_):
            return
        }
    }
    
    func testResponseIsCloudy() {
        
    }
    
    func testResponseIsRainy() {
        
    }

}
