//
//  WeatherViewController.swift
//  Yumemi-ios-training
//
//  Created by 工藤 海斗 on 2022/03/24.
//

import UIKit

class WeatherViewController: UIViewController {
    @IBOutlet weak var weatherTableView: UITableView!
    private var presenter: WeatherPresenterProtocolInput!
    private var refreshControl: UIRefreshControl!
    private var loadingView: UIView!
    private var isLoadingView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = WeatherPresenter(view: self, model: WeatherFetcher())
        NotificationCenter.default.addObserver(self, selector: #selector(viewWillEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        weatherTableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherTableViewCell")
        refreshControl = UIRefreshControl()
        weatherTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        isLoadingView.toggle()
        presenter.fetchWeather(isLoadingView: isLoadingView)
    }
    
    deinit {
        print("\(type(of: self)): " + #function)
    }
    
    @objc func viewWillEnterForeground(_ notification: Notification) {
        isLoadingView.toggle()
        presenter.fetchWeather(isLoadingView: isLoadingView)
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        presenter.fetchWeather(isLoadingView: isLoadingView)
    }
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRepositories
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
        let repository = presenter.repositories[indexPath.row]
        cell.configure(weatherResponses: repository)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(presenter.repositories[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

@MainActor extension WeatherViewController: WeatherPresenterProtocolOutput {
    func showErrorAlert(with message: String?) {
        let alert = UIAlertController(title: R.string.message.alertControllerTitle(), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: R.string.message.alertActionTitle(), style: .default))
        present(alert, animated: true)
    }
    
    func reloadWeatherTableView() {
        weatherTableView.reloadData()
    }
    
    func stopRefreshControl() {
        refreshControl.endRefreshing()
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
        isLoadingView.toggle()
    }
}
