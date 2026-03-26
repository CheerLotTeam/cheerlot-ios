//
//  AppDelegate.swift
//  CheerLot
//
//  Created by 이현주 on 2/9/26.
//

import FirebaseCore
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {

    FirebaseApp.configure()

    if let uuid = UIDevice.current.identifierForVendor?.uuidString {
      DIContainer.shared.resolve(AnalyticsService.self).setUserId(uuid)
    }

    return true
  }
}
