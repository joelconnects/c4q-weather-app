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
  private var initialControllerViewAppeared: Bool = false
  
  // MARK: - View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureBackgroundImageView()
    configureContainerView()
    loadInitialViewController()
    addNotificationObservers()
  }
  
  deinit {
    removeNotificationObservers()
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
  
  // MARK: - Notifications
  private func addNotificationObservers() {
    NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: .loaderViewControllerViewAppeared, object: nil)
  }
  
  private func removeNotificationObservers() {
    NotificationCenter.default.removeObserver(self, name: .loaderViewControllerViewAppeared, object: nil)
  }
  
  @objc
  private func handleNotification(_ notification: Notification) {
    switch notification.name {
    case .loaderViewControllerViewAppeared:
      print("initial view appeared")
    default:
      print("default")
    }
  }
  
  // MARK: Helpers
  private func loadForecastView() {
    let router = AerisRouter(zipCode: "11101")
    AerisAPIClient.request(router) { (result) in
      switch result {
      case .success(let forecast):
        let mainViewModel = MainViewModel(forecast: forecast)
        print("success")
      case .failure(let error):
        print("ERROR - AppDelegate: \(error.localizedDescription)")
      }
    }
  }
  
  private func switchTo(_ viewController: UIViewController, _ completion: () -> ()) {
    let exitingViewController = actingViewController
    exitingViewController?.willMove(toParentViewController: nil)
    
    actingViewController = viewController
    self.addChildViewController(actingViewController)
    
    containerView.addSubview(actingViewController.view)
    actingViewController.view.frame = containerView.bounds
    actingViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    actingViewController.view.alpha = 0
    
    UIView.animate(withDuration: 0.5, animations: {
      
      self.actingViewController.view.alpha = 1
      exitingViewController?.view.alpha = 0
      
    }) { completed in
      exitingViewController?.view.removeFromSuperview()
      exitingViewController?.removeFromParentViewController()
      self.actingViewController.didMove(toParentViewController: self)
    }
  }
}
