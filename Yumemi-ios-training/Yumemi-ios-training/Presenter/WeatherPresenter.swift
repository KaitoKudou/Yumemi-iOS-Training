//
//  WeatherPresenter.swift
//  Yumemi-ios-training
//
//  Created by 工藤 海斗 on 2022/03/24.
//

import Foundation

protocol WeatherPresenterProtocolInput {
    func fetchWeather()
    var delegate: WeatherPresenterProtocolOutput? { get set }
}

protocol WeatherPresenterProtocolOutput: AnyObject {
    func showWeather(weatherResponse: WeatherResponse)
    func showErrorAlert(with message: String?)
    func startIndicatorAnimating()
    func stopIndicatorAnimating()
}

class WeatherPresenter: WeatherPresenterProtocolInput {
    
    weak var delegate: WeatherPresenterProtocolOutput?
    let model: WeatherFetchable
    
    init() {
        self.model = WeatherFetcher()
    }
    
    func fetchWeather() {
        delegate?.startIndicatorAnimating()
        DispatchQueue.global().async {
            defer {
                DispatchQueue.main.async {
                    self.delegate?.stopIndicatorAnimating()
                }
            }
            switch self.model.fetchWeather() {
            case .success(let weather):
                DispatchQueue.main.async {
                    self.delegate?.showWeather(weatherResponse: weather)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.showErrorAlert(with: error.errorDescription)
                }
            }
        }
    }
}
