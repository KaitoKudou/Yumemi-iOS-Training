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
        presenter = WeatherPresenter(view: self, model: WeatherFetcher())
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
        DispatchQueue.main.async {
            let alert = UIAlertController(title: R.string.message.alertControllerTitle(), message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: R.string.message.alertActionTitle(), style: .default))
            self.present(alert, animated: true)
        }
    }
    
    func showWeather(weatherResponse: WeatherResponse) {
        switch weatherResponse.weather {
        case .sunny:
            DispatchQueue.main.async {
                self.weatherImageView.image = R.image.sunny()
                self.weatherImageView.tintColor = R.color.red()
            }
        case .cloudy:
            DispatchQueue.main.async {
                self.weatherImageView.image = R.image.cloudy()
                self.weatherImageView.tintColor = R.color.gray()
            }
        case .rainy:
            DispatchQueue.main.async {
                self.weatherImageView.image = R.image.rainy()
                self.weatherImageView.tintColor = R.color.blue()
            }
        }
        DispatchQueue.main.async {
            self.minTemperatureLabel.text = String(weatherResponse.minTemp)
            self.maxTemperatureLabel.text = String(weatherResponse.maxTemp)
        }
    }
    
    func startIndicatorAnimating() {
        DispatchQueue.main.async {
            self.activityIndicatorView.startAnimating()
            self.closeButton.isEnabled = false
            self.reloadButton.isEnabled = false
        }
    }
    
    func stopIndicatorAnimating() {
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
            self.closeButton.isEnabled = true
            self.reloadButton.isEnabled = true
        }
    }
}
