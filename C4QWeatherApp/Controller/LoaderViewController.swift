//
//  LoaderViewController.swift
//  C4QWeatherApp
//
//  Created by Joel Bell on 10/30/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import UIKit

class LoaderViewController: UIViewController {
  
  // MARK: - Properties
  private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
  
  // MARK: - View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(activityIndicator)
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60).isActive = true
    
    activityIndicator.startAnimating()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    NotificationCenter.default.post(name: .loaderViewControllerViewAppeared, object: nil)
  }
}
