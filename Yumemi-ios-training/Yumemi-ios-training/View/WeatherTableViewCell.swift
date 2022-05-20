//
//  WeatherTableViewCell.swift
//  Yumemi-ios-training
//
//  Created by 工藤 海斗 on 2022/04/27.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    
    func configure(weatherListResponse: WeatherListResponse) {
        switch weatherListResponse.info.weather {
        case .sunny:
            weatherImageView.image = R.image.sunny()
            weatherImageView.tintColor = R.color.red()
        case .cloudy:
            weatherImageView.image = R.image.cloudy()
            weatherImageView.tintColor = R.color.gray()
        case .rainy:
            weatherImageView.image = R.image.rainy()
            weatherImageView.tintColor = R.color.blue()
        }
        areaLabel.text = weatherListResponse.area
        minTemperatureLabel.text = String(weatherListResponse.info.minTemp)
        maxTemperatureLabel.text = String(weatherListResponse.info.maxTemp)
    }
}
