//
//  DayForecastView.swift
//  C4QWeatherApp
//
//  Created by Joel Bell on 10/30/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import UIKit

class DayForecastView: UIView {
  
  enum DegreeType {
    case fahrenheit, celsius
  }
  
  // MARK: - Properties
  let displayDay: ForecastViewModel.DisplayDay
  var degreeType: DegreeType = .fahrenheit {
    didSet {
      switchDisplayForDegreeType()
    }
  }
  
  // MARK: - Initialization  
  init(day: ForecastViewModel.DisplayDay) {
    self.displayDay = day
    super.init(frame: CGRect.zero)
    backgroundColor = UIColor.white.withAlphaComponent(0.2)
    
    dayLabel.text = day.displayDay
    iconView.image = UIImage(named: day.iconIdentifier)
    hiTempLabel.text = day.displayMaxTempF
    loTempLabel.text = day.displayMinTempF
    
    configureViewHierarchy()
    configureConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init?(coder:) is not supported")
  }
  
  // MARK: - Lazy initialization
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .fillProportionally
    stackView.spacing = 5
    return stackView
  }()
  
  private lazy var dayLabel: UILabel = {
    let label = UILabel()
    label.text = "Mon"
    label.numberOfLines = 1
    label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    label.textColor = .white
    label.textAlignment = .center
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5
    label.lineBreakMode = .byTruncatingTail
    return label
  }()
  
  private lazy var iconView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "pcloudyrw")
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private lazy var hiTempLabel: UILabel = {
    let label = UILabel()
    label.text = "H: 80°"
    label.numberOfLines = 1
    label.font = UIFont.systemFont(ofSize: 14, weight: .light)
    label.textColor = .white
    label.textAlignment = .center
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5
    label.lineBreakMode = .byTruncatingTail
    return label
  }()
  
  private lazy var loTempLabel: UILabel = {
    let label = UILabel()
    label.text = "L: 80°"
    label.numberOfLines = 1
    label.font = UIFont.systemFont(ofSize: 14, weight: .light)
    label.textColor = .white
    label.textAlignment = .center
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5
    label.lineBreakMode = .byTruncatingTail
    return label
  }()
  
  // MARK: - View configuration
  private func configureViewHierarchy() {
    addSubview(stackView)
    stackView.addArrangedSubview(dayLabel)
    stackView.addArrangedSubview(iconView)
    stackView.addArrangedSubview(hiTempLabel)
    stackView.addArrangedSubview(loTempLabel)
  }
  
  private func configureConstraints() {
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.topAnchor.constraint(equalTo: topAnchor, constant: 3).isActive = true
    stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 3).isActive = true
    stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3).isActive = true
    stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -3).isActive = true
  }
  
  // MARK: - Helpers
  private func switchDisplayForDegreeType() {
    switch degreeType {
    case .fahrenheit:
      hiTempLabel.text = displayDay.displayMaxTempF
      loTempLabel.text = displayDay.displayMinTempF
    case .celsius:
      hiTempLabel.text = displayDay.displayMaxTempC
      loTempLabel.text = displayDay.displayMinTempC
    }
  }
}
