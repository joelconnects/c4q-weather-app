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
  
  // MARK: - Lazy initialization
  private lazy var locationLabel: UILabel = {
    let label = UILabel()
    label.text = viewModel.locationTitle
    label.numberOfLines = 1
    label.font = UIFont.systemFont(ofSize: 26, weight: .heavy)
    label.textColor = .white
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5
    label.lineBreakMode = .byTruncatingTail
    return label
  }()
  
  private lazy var dailyStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.spacing = 3
    return stackView
  }()
  
  private lazy var tempControlStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fill
    return stackView
  }()
  
  private lazy var tempSwitch: UISwitch = {
    let tempSwitch = UISwitch()
    tempSwitch.onTintColor = .white
    tempSwitch.tintColor = .white
    tempSwitch.thumbTintColor = .black
    tempSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
    tempSwitch.addTarget(self, action: #selector(tempSwitchFlipped(_:)), for: .valueChanged)
    return tempSwitch
  }()
  
  // MARK: - View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureOpeningBackground()
    configureViewHierarchy()
    configureConstraints()
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
  
  private func configureViewHierarchy() {
    view.addSubview(locationLabel)
    view.addSubview(dailyStackView)
    view.addSubview(tempControlStackView)
    
    for day in viewModel.days {
      dailyStackView.addArrangedSubview(DayForecastView(day: day))
    }

    tempControlStackView.addArrangedSubview(generateTempControlLabel(text: "fahrenheit"))
    tempControlStackView.addArrangedSubview(tempSwitch)
    tempControlStackView.addArrangedSubview(generateTempControlLabel(text: "celsius"))
  }
  
  private func configureConstraints() {
    locationLabel.translatesAutoresizingMaskIntoConstraints = false
    locationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
    locationLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
    locationLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true

    dailyStackView.translatesAutoresizingMaskIntoConstraints = false
    dailyStackView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 20).isActive = true
    dailyStackView.leftAnchor.constraint(equalTo: locationLabel.leftAnchor).isActive = true
    dailyStackView.rightAnchor.constraint(equalTo: locationLabel.rightAnchor).isActive = true
    
    tempControlStackView.translatesAutoresizingMaskIntoConstraints = false
    tempControlStackView.topAnchor.constraint(equalTo: dailyStackView.bottomAnchor, constant: 10).isActive = true
    tempControlStackView.rightAnchor.constraint(equalTo: locationLabel.rightAnchor).isActive = true
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
  
  private func generateTempControlLabel(text: String) -> UILabel {
    let label = UILabel()
    label.text = text.uppercased()
    label.numberOfLines = 1
    label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    label.textColor = .white
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5
    return label
  }
  
  // MARK: - Actions
  @objc
  private func tempSwitchFlipped(_ tempSwitch: UISwitch) {
    for view in dailyStackView.arrangedSubviews {
      if let dayView = view as? DayForecastView {
        if tempSwitch.isOn {
          dayView.degreeType = .celsius
        } else {
          dayView.degreeType = .fahrenheit
        }
      }
    }
  }
}
