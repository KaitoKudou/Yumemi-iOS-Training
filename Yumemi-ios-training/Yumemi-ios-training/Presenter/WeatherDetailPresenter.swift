//
//  WeatherDetailPresenter.swift
//  Yumemi-ios-training
//
//  Created by 工藤 海斗 on 2022/05/12.
//

import Foundation

protocol WeatherDetailPresenterProtocolInput {
    var numberOfRepositories: Int { get }
    var repositories: [WeatherResponse] { get }
    func fetchWeather(area: String, date: Date)
}

@MainActor protocol WeatherDetailPresenterProtocolOutput: AnyObject {
    func showErrorAlert(with message: String?)
    func reloadWeatherDetailTableView()
    func showIndicator()
    func removeIndicator()
}

class WeatherDetailPresenter: WeatherDetailPresenterProtocolInput {
    
    weak var view: WeatherDetailPresenterProtocolOutput?
    let model: WeatherFetchable
    private(set) var repositories: [WeatherResponse] = []
    var numberOfRepositories: Int {
        return repositories.count
    }
    
    init(view: WeatherDetailPresenterProtocolOutput, model: WeatherFetchable) {
        self.view = view
        self.model = WeatherFetcher()
    }
    
    func fetchWeather(area: String, date: Date) {
        Task {
            await self.view?.showIndicator()
            defer {
                Task {
                    await self.view?.removeIndicator()
                    self.repositories.sort(by: {$0.date < $1.date})
                    await self.view?.reloadWeatherDetailTableView()
                }
            }
            for index in 1 ..< 4 {
                guard let modifiedDate = Calendar.current.date(byAdding: .day, value: index, to: date) else { return }
                switch await self.model.fetchWeather(area: area, date: modifiedDate) {
                case .success(let weatherList):
                    self.repositories.append(weatherList)
                case .failure(let error):
                    await self.view?.showErrorAlert(with:error.errorDescription)
                }
            }
        }
    }
}
