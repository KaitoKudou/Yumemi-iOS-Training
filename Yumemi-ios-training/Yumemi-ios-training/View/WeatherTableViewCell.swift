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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(weatherResponses: WeatherListResponse) {
        switch weatherResponses.info.weather {
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
        areaLabel.text = weatherResponses.area
        minTemperatureLabel.text = String(weatherResponses.info.minTemp)
        maxTemperatureLabel.text = String(weatherResponses.info.maxTemp)
    }
}
