//
//  WeatherDetailViewController.swift
//  Yumemi-ios-training
//
//  Created by 工藤 海斗 on 2022/05/12.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    @IBOutlet weak var WeatherImageView: UIImageView!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    var weatherDetailInfo: WeatherListResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = weatherDetailInfo?.area
        showWeather()
    }
    
    private func showWeather() {
        guard let weatherDetailInfo = weatherDetailInfo else { return }
        switch weatherDetailInfo.info.weather {
        case .sunny:
            WeatherImageView.image = R.image.sunny()
            WeatherImageView.tintColor = R.color.red()
        case .cloudy:
            WeatherImageView.image = R.image.cloudy()
            WeatherImageView.tintColor = R.color.gray()
        case .rainy:
            WeatherImageView.image = R.image.rainy()
            WeatherImageView.tintColor = R.color.blue()
        }
        minTemperatureLabel.text = String(weatherDetailInfo.info.minTemp)
        maxTemperatureLabel.text = String(weatherDetailInfo.info.maxTemp)
    }
}
