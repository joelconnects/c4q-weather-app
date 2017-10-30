//
//  AppController.swift
//  C4QWeatherApp
//
//  Created by Joel Bell on 10/30/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import UIKit

class AppController: UIViewController {
  
  // MARK: - Properties
  private var containerView: UIView!
  private var actingViewController: UIViewController!
  private var backgroundImageView: UIImageView!
  
  // MARK: - View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureBackgroundImageView()
    configureContainerView()
    loadInitialViewController()
//    addNotificationObservers()
    loadForecastViewController()
  }

  
  deinit {
//    removeNotificationObservers()
  }
  
  // MARK: View configuration
  private func configureBackgroundImageView() {
    backgroundImageView = UIImageView(image: Theme.Images.AppBackground)
    backgroundImageView.contentMode = .scaleAspectFill
    view.addSubview(backgroundImageView)
    
    backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
    backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    backgroundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    backgroundImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    backgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
  }
  
  private func configureContainerView() {
    containerView = UIView()
    containerView.frame = view.frame
    containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(containerView)
  }
  
  private func loadInitialViewController() {
    actingViewController = LoaderViewController()
    self.addChildViewController(actingViewController)
    containerView.addSubview(actingViewController.view)
    actingViewController.view.frame = containerView.bounds
    actingViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    actingViewController.didMove(toParentViewController: self)
  }
  
  private func loadForecastViewController() {
    getForecast { forecastViewModel in
      if let viewModel = forecastViewModel {
        let forecastViewController = ForecastViewController(viewModel: viewModel)
        self.switchTo(forecastViewController)
      }
    }
  }
  
//  // MARK: - Notifications
//  private func addNotificationObservers() {
//    NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: .loaderViewControllerViewAppeared, object: nil)
//  }
//
//  private func removeNotificationObservers() {
//    NotificationCenter.default.removeObserver(self, name: .loaderViewControllerViewAppeared, object: nil)
//  }
//
//  @objc
//  private func handleNotification(_ notification: Notification) {
//    switch notification.name {
//    case .loaderViewControllerViewAppeared:
//      print("initial view appeared")
//    default:
//      print("default")
//    }
//  }
  
  // MARK: Helpers
  private func getForecast(completion: @escaping (ForecastViewModel?) -> ()) {
    let router = AerisRouter(zipCode: "11101")
    AerisAPIClient.request(router) { result in
      DispatchQueue.main.async {
        switch result {
        case .success(let forecast):
          completion(ForecastViewModel(forecast: forecast))
        case .failure(let error):
          // TODO: Set up retry flow
          self.presentDefaultAlert(title: "Uh oh!", message: error.localizedDescription)
          completion(nil)
        }
      }
    }
  }
  
  private func switchTo(_ viewController: UIViewController) {
    let exitingViewController = actingViewController
    exitingViewController?.willMove(toParentViewController: nil)
    
    actingViewController = viewController
    self.addChildViewController(actingViewController)
    
    containerView.addSubview(actingViewController.view)
    actingViewController.view.frame = containerView.bounds
    
    actingViewController.view.translatesAutoresizingMaskIntoConstraints = false
    actingViewController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
    actingViewController.view.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    let widthConstraint = actingViewController.view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 2)
    let heightConstraint = actingViewController.view.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 2)
    widthConstraint.isActive = true
    heightConstraint.isActive = true
    containerView.layoutIfNeeded()
    
    actingViewController.view.alpha = 0
    
    widthConstraint.constant = UIScreen.main.bounds.width
    heightConstraint.constant = UIScreen.main.bounds.height
    
    UIView.animate(withDuration: 0.4, animations: {
      self.containerView.layoutIfNeeded()
      self.actingViewController.view.alpha = 1
      exitingViewController?.view.alpha = 0
      
    }) { completed in
      exitingViewController?.view.removeFromSuperview()
      exitingViewController?.removeFromParentViewController()
      self.actingViewController.didMove(toParentViewController: self)
    }
  }
  
  private func presentDefaultAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(OKAction)
    present(alertController, animated: true, completion: nil)
  }
}
