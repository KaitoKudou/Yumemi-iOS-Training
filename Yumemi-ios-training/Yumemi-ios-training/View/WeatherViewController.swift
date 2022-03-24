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
    private var weatherString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = WeatherPresenter(view: self, model: WeatherModel())
        inject(presenter: presenter)
    }
    
    func inject(presenter: WeatherPresenterProtocolInput) {
        self.presenter = presenter
    }
    
    @IBAction func reloadWeather(_ sender: Any) {
        weatherString = presenter.didTapReloadButton()
        switch weatherString {
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

extension WeatherViewController: WeatherPresenterProtocolOutput {
    func showWeather() {
    }
}
