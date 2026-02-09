//
//  AppDelegate.swift
//  CheerLot
//
//  Created by 이현주 on 2/9/26.
//

import Foundation
import FirebaseCore
import AdSupport
import AppTrackingTransparency
import FirebaseAnalytics

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
      
      FirebaseApp.configure()
      
      if let uuid = UIDevice.current.identifierForVendor?.uuidString {
          Analytics.setUserID(uuid)
      }
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          self.requestTrackingAuthorization()
      }
      
      return true
  }
    
    private func requestTrackingAuthorization() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    Analytics.setAnalyticsCollectionEnabled(true)
                default:
                    Analytics.setAnalyticsCollectionEnabled(false)
                }
            }
        }
    }
}
