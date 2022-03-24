//
//  WeatherPresenter.swift
//  Yumemi-ios-training
//
//  Created by 工藤 海斗 on 2022/03/24.
//

import Foundation

protocol WeatherPresenterProtocolInput {
    func didTapReloadButton() -> String
}

protocol WeatherPresenterProtocolOutput: AnyObject {
    func showWeather()
}

class WeatherPresenter: WeatherPresenterProtocolInput {
    weak var view: WeatherPresenterProtocolOutput!
    var model: WeatherModelProtocol!
    
    init(view: WeatherPresenterProtocolOutput, model: WeatherModelProtocol) {
        self.view = view
        self.model = model
    }
    
    func didTapReloadButton() -> String {
        return model.fetchWeather()
    }
}
