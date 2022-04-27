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

@MainActor protocol WeatherPresenterProtocolOutput: AnyObject {
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
        Task {
            await self.view?.startIndicatorAnimating()
            defer {
                Task {
                    await self.view?.stopIndicatorAnimating()
                }
            }
            switch await self.model.fetchWeather() {
            case .success(let weather):
                await self.view?.showWeather(weatherResponse: weather)
            case .failure(let error):
                await self.view?.showErrorAlert(with:error.errorDescription)
            }
        }
    }
}
