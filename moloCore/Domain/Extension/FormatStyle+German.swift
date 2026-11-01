//
//  FormatStyle+German.swift
//  Domain
//

import Foundation

public extension FormatStyle where Self == Date.FormatStyle {
    static var germanDate: Date.FormatStyle {
        .dateTime
            .day(.twoDigits)
            .month(.twoDigits)
            .year(.defaultDigits)
            .locale(Locale(identifier: "de_DE"))
    }

    static var germanTime: Date.FormatStyle {
        .dateTime
            .hour(.twoDigits(amPM: .omitted))
            .minute(.twoDigits)
            .locale(Locale(identifier: "de_DE"))
    }

    static var germanDateTime: Date.FormatStyle {
        .dateTime
            .day(.twoDigits)
            .month(.twoDigits)
            .year(.defaultDigits)
            .hour(.twoDigits(amPM: .omitted))
            .minute(.twoDigits)
            .locale(Locale(identifier: "de_DE"))
    }

    static var germanWeekday: Date.FormatStyle {
        .dateTime
            .weekday(.wide)
            .locale(Locale(identifier: "de_DE"))
    }
    
    static var germanDateTimeWithFullMonth: Date.FormatStyle {
        .dateTime
        .day(.defaultDigits)
        .month(.wide)
        .hour(.twoDigits(amPM: .omitted))
        .minute(.twoDigits)
        .locale(Locale(identifier: "de_DE"))
    }
    
    static var germanDateTimeWithFullMonthOmittingTime: Date.FormatStyle {
        .dateTime
        .day(.defaultDigits)
        .month(.wide)
        .locale(Locale(identifier: "de_DE"))
    }
}
