//
//  InitialViewController.swift
//  Yumemi-ios-training
//
//  Created by 工藤 海斗 on 2022/03/30.
//

import UIKit

class InitialViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performSegue(withIdentifier: R.segue.initialViewController.toWeatherViewController, sender: nil)
    }
}
