//
//  AmplitudeAnalyticsService.swift
//  CheerLot
//
//  Created by 이현주 on 3/25/26.
//

import AmplitudeUnified
import Foundation

final class AmplitudeAnalyticsService: AnalyticsService {
  private let amplitude: Amplitude

  init() {
    amplitude = Amplitude(configuration: Configuration(apiKey: Config.amplitudeKey))
  }

  func track(_ event: any AnalyticsEvent) {
    amplitude.track(eventType: event.name, eventProperties: event.parameters)
  }

  func setUserId(_ id: String) {
    amplitude.setUserId(userId: id)
  }

  func setUserProperty(_ key: AnalyticsUserProperty, value: Any) {
    let identify = Identify()
    identify.set(property: key.rawValue, value: value as AnyObject)
    amplitude.identify(identify: identify)
  }

  func incrementUserProperty(_ key: AnalyticsUserProperty) {
    let identify = Identify()
    identify.add(property: key.rawValue, value: 1.0)
    amplitude.identify(identify: identify)
  }
}

