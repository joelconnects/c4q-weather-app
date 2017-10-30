//
//  ForecastViewController.swift
//  C4QWeatherApp
//
//  Created by Joel Bell on 10/30/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {
  
  // MARK: - Properties
  let viewModel: ForecastViewModel
  var openingBackgroundImageView: UIImageView!
  
  // MARK: - Initialization
  init(viewModel: ForecastViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init?(coder:) is not supported")
  }
  
  // MARK: - View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureOpeningBackground()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    removeOpeningBackgroundImageView()
  }
  
  // MARK: - View configuration
  private func configureOpeningBackground() {
    openingBackgroundImageView = UIImageView(image: Theme.Images.AppBackgroundInverted)
    openingBackgroundImageView.contentMode = .scaleAspectFill
    openingBackgroundImageView.alpha = 1
    view.addSubview(openingBackgroundImageView)
    
    openingBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
    openingBackgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    openingBackgroundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    openingBackgroundImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    openingBackgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
  }
  
  // MARK: - Helpers
  private func removeOpeningBackgroundImageView() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
      if self.view.subviews.contains(self.openingBackgroundImageView) {
        UIView.animate(withDuration: 0.4, animations: {
          self.openingBackgroundImageView.alpha = 0
        }, completion: { _ in
          self.openingBackgroundImageView.removeFromSuperview()
        })
      }
    }
  }
}
