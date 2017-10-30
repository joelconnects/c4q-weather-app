//
//  ForecastViewModel.swift
//  C4QWeatherApp
//
//  Created by Joel Bell on 10/29/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import Foundation

struct ForecastViewModel {
  
  // MARK: - Properties
  let days: [DisplayDay]
  
  let locationTitle: String = "Long Island City, NY"
  
  // MARK: - Initialization
  init(forecast: Forecast) {
    var days: [DisplayDay] = []
    for (index, day) in forecast.days.enumerated() {
      if index < 5 {
        days.append(DisplayDay(day: day))
      } else {
        continue
      }
    }
    self.days = days
  }
  
  struct DisplayDay {
    // MARK: - Properties
    let displayMinTempF: String
    let displayMaxTempF: String
    let displayMinTempC: String
    let displayMaxTempC: String
    let iconIdentifier: String
    let displayDay: String
    
    // MARK: - Initialization
    init(day: Forecast.Day) {
      self.displayMinTempF = "L: \(day.minTempF)°"
      self.displayMaxTempF = "H: \(day.maxTempF)°"
      self.displayMinTempC = "L: \(day.minTempC)°"
      self.displayMaxTempC = "H: \(day.maxTempC)°"
      self.iconIdentifier = day.icon
      self.displayDay = DisplayDay.generateAbbreviatedDay(from: day.date)
    }
    
    // MARK: - Helpers
    private static func generateAbbreviatedDay(from dateString: String) -> String {
      let isoFormatter = ISO8601DateFormatter()
      if let date = isoFormatter.date(from: dateString) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: date).uppercased()
      } else {
        print("ERROR - ForecastViewModel: Unable to format date")
        return ""
      }
    }
  }
}
