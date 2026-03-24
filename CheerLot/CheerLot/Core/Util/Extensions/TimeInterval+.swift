//
//  TimeInterval+.swift
//  CheerLot
//
//  Created by 이현주 on 3/24/26.
//

import Foundation

extension TimeInterval {
  var asTimeString: String {
    let minutes = Int(self) / 60
    let seconds = Int(self) % 60
    return String(format: "%02d:%02d", minutes, seconds)
  }
}
