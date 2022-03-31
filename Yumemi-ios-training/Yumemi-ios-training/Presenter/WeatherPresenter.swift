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
}

class WeatherPresenter: WeatherPresenterProtocolInput {
    
    weak var view: WeatherPresenterProtocolOutput?
    let model: WeatherFetchable
    
    init(view: WeatherPresenterProtocolOutput, model: WeatherFetchable) {
        self.view = view
        self.model = model
    }
    
    func fetchWeather() {
        switch model.fetchWeaher() {
        case .success(let weather):
            self.view?.showWeather(weatherResponse: weather)
        case .failure(let error as APIError):
            view?.showErrorAlert(with: error.errorDescription)
        case .failure(let error as JsonError):
            view?.showErrorAlert(with: error.errorDescription)
        default:
            return
        }
    }
}
