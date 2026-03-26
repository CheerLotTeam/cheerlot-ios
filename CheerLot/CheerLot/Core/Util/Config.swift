//
//  Config.swift
//  CheerLot
//
//  Created by 이현주 on 5/29/25.
//

import Foundation

enum Config {
  private static let infoDictionary: [String: Any] = {
    guard let dict = Bundle.main.infoDictionary else {
      fatalError("Plist 없음")
    }
    return dict
  }()

  static let apiURL: String = {
    guard let apiURL = infoDictionary["API_URL"] as? String else {
      fatalError()
    }
    return apiURL
  }()

  static let streamAudioURL: String = {
    guard let streamAudioURL = infoDictionary["STREAM_AUDIO_URL"] as? String else {
      fatalError()
    }
    return streamAudioURL
  }()

  static let amplitudeKey: String = {
    guard let amplitudeKey = infoDictionary["AMPLITUDE_KEY"] as? String else {
      fatalError()
    }
    return amplitudeKey
  }()
}
