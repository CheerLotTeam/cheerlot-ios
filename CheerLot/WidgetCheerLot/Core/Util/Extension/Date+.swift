//
//  Date+.swift
//  WidgetCheerLotExtension
//
//  Created by 이현주 on 4/10/26.
//

import Foundation

extension Date {
    private static let dayOfWeekFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        formatter.locale = Locale(identifier: "en_US")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter
    }()
    
    private static let dayOfMonthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
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
    
    private static let slashDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter
    }()
    
    // ex. Wed
    var dayOfWeek: String { Date.dayOfWeekFormatter.string(from: self) }
    
    // ex. 27
    var dayOfMonth: String { Date.dayOfMonthFormatter.string(from: self) }
    
    // ex. 4월 10일
    var koreanDateFormatted: String { Date.koreanDateFormatter.string(from: self) }
    
    // ex. 04/10
    var slashDateFormatted: String { Date.slashDateFormatter.string(from: self) }
}
