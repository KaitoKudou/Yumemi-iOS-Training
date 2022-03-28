//
//  WeatherPresenter.swift
//  Yumemi-ios-training
//
//  Created by 工藤 海斗 on 2022/03/24.
//

import Foundation

protocol WeatherPresenterProtocolInput {
    func feachWeather()
}

protocol WeatherPresenterProtocolOutput: AnyObject {
    func showWeather(weaherType: WeatherType)
    func showErrorAlert(errorMessage: String)
}

class WeatherPresenter: WeatherPresenterProtocolInput {
    
    weak var view: WeatherPresenterProtocolOutput?
    let model: WeatherModelProtocol
    
    init(view: WeatherPresenterProtocolOutput, model: WeatherModelProtocol) {
        self.view = view
        self.model = model
    }
    
    func feachWeather() {
        switch model.feachWeaher() {
        case .success(let weather):
            self.view?.showWeather(weaherType: weather)
        case .failure(let error):
            switch error {
            case .invalidParameterError:
                view?.showErrorAlert(errorMessage: error.errorDescription!)
            case .unknownError:
                view?.showErrorAlert(errorMessage: error.errorDescription!)
            }
        }
    }
}
