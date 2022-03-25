//
//  WeatherViewController.swift
//  Yumemi-ios-training
//
//  Created by 工藤 海斗 on 2022/03/24.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var weatherImageView: UIImageView!
    private var presenter: WeatherPresenterProtocolInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = WeatherPresenter(view: self, model: WeatherModel())
    }
    
    @IBAction func reloadWeather(_ sender: Any) {
        presenter.feachWeather()
    }
}

extension WeatherViewController: WeatherPresenterProtocolOutput {
    func showWeather(weaherType: WeatherType) {
        switch weaherType.rawValue {
        case "sunny":
            weatherImageView.image = R.image.sunny()
            weatherImageView.tintColor = R.color.red()
        case "cloudy":
            weatherImageView.image = R.image.cloudy()
            weatherImageView.tintColor = R.color.gray()
        case "rainy":
            weatherImageView.image = R.image.rainy()
            weatherImageView.tintColor = R.color.blue()
        default:
            return
        }
    }
}
