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
    func fetchWeather(isLoadingView: Bool, areas: [String], date: Date)
    func didSelectRow(at indexPathRow: Int)
}

@MainActor protocol WeatherPresenterProtocolOutput: AnyObject {
    func showErrorAlert(with message: String?)
    func reloadWeatherTableView()
    func stopRefreshControl()
    func showIndicator()
    func removeIndicator()
    func showWeatherDetailView(index: Int)
}

class WeatherPresenter: WeatherPresenterProtocolInput {
    
    weak var view: WeatherPresenterProtocolOutput?
    let model: WeatherListFetchable
    private(set) var repositories: [WeatherListResponse] = []
    var numberOfRepositories: Int {
        return repositories.count
    }
    
    init(view: WeatherPresenterProtocolOutput, model: WeatherListFetchable) {
        self.view = view
        self.model = WeatherListFetcher()
    }
    
    func fetchWeather(isLoadingView: Bool, areas: [String], date: Date) {
        Task {
            if isLoadingView {
                await self.view?.showIndicator()
            }
            defer {
                if isLoadingView {
                    Task {
                        await self.view?.removeIndicator()
                    }
                }
                Task {
                    await self.view?.stopRefreshControl()
                }
            }
            switch await self.model.fetchWeather(areas: areas, date: date) {
            case .success(let weatherList):
                self.repositories = weatherList
                await self.view?.reloadWeatherTableView()
            case .failure(let error):
                await self.view?.showErrorAlert(with:error.errorDescription)
            }
        }
    }
    
    func didSelectRow(at indexPathRow: Int) {
        Task {
            await view?.showWeatherDetailView(index: indexPathRow)
        }
    }
}
