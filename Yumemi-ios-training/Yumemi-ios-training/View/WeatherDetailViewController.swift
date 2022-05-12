//
//  WeatherDetailViewController.swift
//  Yumemi-ios-training
//
//  Created by 工藤 海斗 on 2022/05/12.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    @IBOutlet weak var WeatherDetailTableView: UITableView!
    private var presenter: WeatherDetailPresenterProtocolInput!
    private var loadingView: UIView!
    var area: String?
    var date: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = area
        presenter = WeatherDetailPresenter(view: self, model: WeatherFetcher())
        WeatherDetailTableView.delegate = self
        WeatherDetailTableView.dataSource = self
        WeatherDetailTableView.register(UINib(nibName: "WeatherDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherDetailTableViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let date = date, let area = area else { return }
        presenter.fetchWeather(area: area, date: date)
    }
    
    func fetchWeather() async {
        guard let date = date, let area = area else { return }
        for index in 1 ..< 8 {
            guard let modifiedDate = Calendar.current.date(byAdding: .day, value: index, to: date) else { return }
            presenter.fetchWeather(area: area, date: modifiedDate)
        }
    }
}

extension WeatherDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRepositories
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherDetailTableViewCell", for: indexPath) as! WeatherDetailTableViewCell
        let repository = presenter.repositories[indexPath.row]
        cell.configure(weatherResponses: repository)
        return cell
    }
}

extension WeatherDetailViewController: WeatherDetailPresenterProtocolOutput {
    func showErrorAlert(with message: String?) {
        let alert = UIAlertController(title: R.string.message.alertControllerTitle(), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: R.string.message.alertActionTitle(), style: .default))
        present(alert, animated: true)
    }
    
    func reloadWeatherDetailTableView() {
        WeatherDetailTableView.reloadData()
    }
    
    func showIndicator() {
        let indicatorView = UIActivityIndicatorView(style: .large)
        loadingView = UIView(frame: self.view.bounds)
        loadingView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        indicatorView.center = loadingView.center
        indicatorView.startAnimating()
        loadingView?.addSubview(indicatorView)
        view.addSubview(loadingView)
    }
    
    func removeIndicator() {
        loadingView.removeFromSuperview()
    }
}
