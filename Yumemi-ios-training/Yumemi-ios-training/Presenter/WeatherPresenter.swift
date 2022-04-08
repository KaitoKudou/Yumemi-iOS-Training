//
//  WeatherPresenter.swift
//  Yumemi-ios-training
//
//  Created by 工藤 海斗 on 2022/03/24.
//

import Foundation

protocol WeatherPresenterProtocolInput {
    func fetchWeather()
}

protocol WeatherPresenterProtocolOutput: AnyObject {
    func showWeather(weatherResponse: WeatherResponse)
    func showErrorAlert(with message: String?)
    func startIndicatorAnimating()
    func stopIndicatorAnimating()
}

class WeatherPresenter: WeatherPresenterProtocolInput {
    
    weak var view: WeatherPresenterProtocolOutput?
    let model: WeatherFetchable
    
    init(view: WeatherPresenterProtocolOutput, model: WeatherFetchable) {
        self.view = view
        self.model = model
    }
    
    func fetchWeather() {
        view?.startIndicatorAnimating()
        DispatchQueue.main.async {
            switch self.model.fetchWeather() {
            case .success(let weather):
                self.view?.showWeather(weatherResponse: weather)
                self.view?.stopIndicatorAnimating()
            case .failure(let error):
                self.view?.showErrorAlert(with: error.errorDescription)
                self.view?.stopIndicatorAnimating()
            }
        }
    }
}
