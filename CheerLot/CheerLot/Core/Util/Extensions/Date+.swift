//
//  Date+.swift
//  CheerLot
//
//  Created by 이현주 on 4/12/26.
//

import Foundation

extension Date {
  private static let yyyyMMddFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    return formatter
  }()

  // ex. 2026-04-12
  var yyyyMMddFormatted: String { Date.yyyyMMddFormatter.string(from: self) }
}
