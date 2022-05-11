//
//  WeatherPresenter.swift
//  Yumemi-ios-training
//
//  Created by 工藤 海斗 on 2022/03/24.
//

import Foundation

protocol WeatherPresenterProtocolInput {
    var numberOfRepositories: Int { get }
    var repositories: [WeatherListResponse] { get }
    func fetchWeather()
}

@MainActor protocol WeatherPresenterProtocolOutput: AnyObject {
    func showErrorAlert(with message: String?)
    func reloadWeatherTableView()
    func stopRefreshControl()
}

class WeatherPresenter: WeatherPresenterProtocolInput {
    
    weak var view: WeatherPresenterProtocolOutput?
    let model: WeatherFetchable
    private(set) var repositories: [WeatherListResponse] = []
    var numberOfRepositories: Int {
        return repositories.count
    }
    
    init(view: WeatherPresenterProtocolOutput, model: WeatherFetchable) {
        self.view = view
        self.model = WeatherFetcher()
    }
    
    func fetchWeather() {
        Task {
            switch await self.model.fetchWeather() {
            case .success(let weatherList):
                self.repositories = weatherList
                await self.view?.reloadWeatherTableView()
                await self.view?.stopRefreshControl()
            case .failure(let error):
                await self.view?.showErrorAlert(with:error.errorDescription)
                await self.view?.stopRefreshControl()
            }
        }
    }
}
