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
    func showWeather(weaherType: WeatherType)
    func showErrorAlert(with message: String)
}

class WeatherPresenter: WeatherPresenterProtocolInput {
    
    weak var view: WeatherPresenterProtocolOutput?
    let model: WeatherFetchable
    
    init(view: WeatherPresenterProtocolOutput, model: WeatherFetchable) {
        self.view = view
        self.model = model
    }
    
    func fetchWeather() {
        switch model.fechWeaher() {
        case .success(let weather):
            self.view?.showWeather(weaherType: weather)
        case .failure(let error):
            switch error {
            case .invalidParameterError:
                view?.showErrorAlert(with: error.errorDescription!)
            case .unknownError:
                view?.showErrorAlert(with: error.errorDescription!)
            }
        }
    }
}
