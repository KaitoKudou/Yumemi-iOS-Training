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
}

class WeatherPresenter: WeatherPresenterProtocolInput {
    
    weak var view: WeatherPresenterProtocolOutput?
    let model: WeatherModelProtocol
    
    init(view: WeatherPresenterProtocolOutput, model: WeatherModelProtocol) {
        self.view = view
        self.model = model
    }
    
    func feachWeather() {
        model.fetchWeather(completion: { [weak self] response in
            self?.view?.showWeather(weaherType: response)
        })
    }
}
