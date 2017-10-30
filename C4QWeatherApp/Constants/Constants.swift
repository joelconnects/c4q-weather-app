//
//  Constants.swift
//  C4QWeatherApp
//
//  Created by Joel Bell on 10/30/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import UIKit

struct Theme {
  struct Images {
    static let AppBackground = UIImage(named: "image-app-background")!
  }
}

extension Notification.Name {
  static let loaderViewControllerViewAppeared = Notification.Name("loader_view_controller_view_appeared")
}
