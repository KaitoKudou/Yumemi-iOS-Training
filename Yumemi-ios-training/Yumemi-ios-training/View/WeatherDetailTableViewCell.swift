//
//  WeatherDetailTableViewCell.swift
//  Yumemi-ios-training
//
//  Created by 工藤 海斗 on 2022/05/12.
//

import UIKit

class WeatherDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    
    func configure(weatherResponses: WeatherResponse) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        switch weatherResponses.weather {
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
        dateLabel.text = dateFormatter.string(from: weatherResponses.date)
        minTemperatureLabel.text = String(weatherResponses.minTemp)
        maxTemperatureLabel.text = String(weatherResponses.maxTemp)
    }
}
