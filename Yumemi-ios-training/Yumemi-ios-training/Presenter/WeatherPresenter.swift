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
        self.model = WeatherFetcher()
    }
    
    func fetchWeather() {
        view?.startIndicatorAnimating()
        DispatchQueue.global().async {
            defer {
                DispatchQueue.main.async {
                    self.view?.stopIndicatorAnimating()
                }
            }
            self.model.fetchWeather { [weak self] result in
                switch result {
                case .success(let weather):
                    DispatchQueue.main.async {
                        self?.view?.showWeather(weatherResponse: weather)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.view?.showErrorAlert(with: error.errorDescription)
                    }
                }
            }
        }
    }
}
