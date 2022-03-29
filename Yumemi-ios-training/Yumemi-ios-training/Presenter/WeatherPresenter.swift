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
    func showDate(date: Date)  // 要件には無いが日付を表示するためのDelegateメソッド
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
            guard let date = dateFormatter(from: weather.date) else { return }
            self.view?.showDate(date: date)
            self.view?.showWeather(weatherResponse: weather)
        case .failure(let error):
            switch error {
            case .invalidParameterError:
                view?.showErrorAlert(with: error.errorDescription)
            case .unknownError:
                view?.showErrorAlert(with: error.errorDescription)
            case .jsonParseError:
                view?.showErrorAlert(with: error.errorDescription)
            }
        }
    }
    
    func dateFormatter(from dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        guard let date = dateFormatter.date(from: dateString) else { return nil }
        return date
    }
}
