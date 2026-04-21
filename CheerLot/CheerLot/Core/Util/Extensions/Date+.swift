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

  private static let koreanDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "M월 d일"
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    return formatter
  }()

  // ex. 2026-04-12
  var yyyyMMddFormatted: String { Date.yyyyMMddFormatter.string(from: self) }

  // ex. 4월 12일
  var koreanDateFormatted: String { Date.koreanDateFormatter.string(from: self) }

  // yyyy-MM-dd 문자열 → Date 파싱
  static func from(yyyyMMdd: String) -> Date? {
    yyyyMMddFormatter.date(from: yyyyMMdd)
  }
}
