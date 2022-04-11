//
//  WeatherViewController.swift
//  Yumemi-ios-training
//
//  Created by 工藤 海斗 on 2022/03/24.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var reloadButton: UIButton!
    private var presenter: WeatherPresenterProtocolInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = WeatherPresenter(view: self)
        NotificationCenter.default.addObserver(self, selector: #selector(viewWillEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    deinit {
        print("\(type(of: self)): " + #function)
    }
    
    @IBAction func reloadWeather(_ sender: Any) {
        presenter.fetchWeather()
    }
    
    @IBAction func closeWeatherView(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @objc func viewWillEnterForeground(_ notification: Notification) {
        presenter.fetchWeather()
    }
}

extension WeatherViewController: WeatherPresenterProtocolOutput {
    func showErrorAlert(with message: String?) {
        let alert = UIAlertController(title: R.string.message.alertControllerTitle(), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: R.string.message.alertActionTitle(), style: .default))
        present(alert, animated: true)
    }
    
    func showWeather(weatherResponse: WeatherResponse) {
        switch weatherResponse.weather {
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
        minTemperatureLabel.text = String(weatherResponse.minTemp)
        maxTemperatureLabel.text = String(weatherResponse.maxTemp)
    }
    
    func startIndicatorAnimating() {
        activityIndicatorView.startAnimating()
        closeButton.isEnabled = false
        reloadButton.isEnabled = false
    }
    
    func stopIndicatorAnimating() {
        activityIndicatorView.stopAnimating()
        closeButton.isEnabled = true
        reloadButton.isEnabled = true
    }
}
