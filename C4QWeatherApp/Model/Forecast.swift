//
//  Forecast.swift
//  C4QWeatherApp
//
//  Created by Joel Bell on 10/29/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import Foundation

struct Forecast: Decodable {
  
  // MARK: - Properties
  let days: [Daily]
  
  // MARK: - Coding keys
  enum CodingKeys: String, CodingKey {
    case response
  }

  // MARK: - Initialization
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: Forecast.CodingKeys.self)
    let response = try container.decode(Response.self, forKey: .response)
    self.days = response.periods
  }
  
  // MARK: - Daily forecast
  struct Daily: Decodable {
    
    // MARK: - Properties
    let minTempF: String
    let maxTempF: String
    let minTempC: String
    let maxTempC: String
    let date: String
    let icon: String
    
    // MARK: - Coding keys
    enum CodingKeys: String, CodingKey {
      case minTempF
      case maxTempF
      case minTempC
      case maxTempC
      case date = "dateTimeISO"
      case icon
    }
    
    // MARK: - Initialization
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: Daily.CodingKeys.self)
      let minTempF = try container.decode(Int.self, forKey: .minTempF)
      let maxTempF = try container.decode(Int.self, forKey: .maxTempF)
      let minTempC = try container.decode(Int.self, forKey: .minTempC)
      let maxTempC = try container.decode(Int.self, forKey: .maxTempC)
      let date = try container.decode(String.self, forKey: .date)
      let icon = try container.decode(String.self, forKey: .icon)
      
      self.minTempF = String(minTempF)
      self.maxTempF = String(maxTempF)
      self.minTempC = String(minTempC)
      self.maxTempC = String(maxTempC)
      self.date = date
      self.icon = icon
    }
  }
  
  // MARK: - Response
  private struct Response: Decodable {
    
    // MARK: - Properties
    let periods: [Daily]
    
    // MARK: - Coding keys
    enum CodingKeys : String, CodingKey {
      case periods
    }
    
    // MARK: - Initialization
    init(from decoder: Decoder) throws {
      var unkeyedContainer = try decoder.unkeyedContainer()
      let nestedContainer = try unkeyedContainer.nestedContainer(keyedBy: Response.CodingKeys.self)
      var periodsArray = try nestedContainer.nestedUnkeyedContainer(forKey: .periods)
      
      var periods: [Daily] = []
      while (!periodsArray.isAtEnd) {
        let daily = try periodsArray.decode(Daily.self)
        periods.append(daily)
      }
      
      self.periods = periods
    }
  }
}
