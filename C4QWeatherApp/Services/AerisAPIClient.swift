//
//  AerisAPIClient.swift
//  C4QWeatherApp
//
//  Created by Joel Bell on 10/29/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import Foundation

struct AerisRouter {
  
  // MARK: - Properties
  private let baseUrl: String = "http://api.aerisapi.com"
  private let path: String = "/forecasts/"
  private let authentication: String = "?client_id=\(Secrets.Aeris.ClientID)&client_secret=\(Secrets.Aeris.ClientSecret)"
  private let method: HTTPMethod = .get
  private var zipCode: String
  
  var urlRequest: URLRequest? {
    guard let url = URL(string: baseUrl + path + zipCode + authentication) else { return nil }
    let urlRequest = URLRequest(url: url)
    return urlRequest
  }
  
  // MARK: - Initialization
  init(zipCode: String) {
    self.zipCode = zipCode
  }
}

struct AerisAPIClient {
  
  // MARK: - Request
  static func request(_ router: AerisRouter, completion: @escaping (ForecastResult) -> ()) {
    guard let request = router.urlRequest else {
      completion(Result.failure(NetworkError.badRequest))
      return
    }
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      let result = ResultParser.parse((data, response, error))
      
      switch result {
      case .success(let data):
        do {
          guard let data = data else {
            completion(Result.failure(NetworkError.parsingError))
            return
          }
          let result = try JSONDecoder().decode(Forecast.self, from: data)
          completion(Result.success(result))
        } catch {
          completion(Result.failure(NetworkError.parsingError))
        }
      case .failure(let error):
        completion(Result.failure(error))
      }
    }.resume()
  }
}
