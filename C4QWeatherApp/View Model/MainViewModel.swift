//
//  MainViewModel.swift
//  C4QWeatherApp
//
//  Created by Joel Bell on 10/29/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import Foundation

struct MainViewModel {
  
  // MARK: - Properties
  let days: [Forecast.Daily]
  
  // MARK: - Initialization
  init(forecast: Forecast) {
    self.days = forecast.days
  }
}
