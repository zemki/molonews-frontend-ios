//
//  Date+.swift
//  Domain
//

import Foundation
import Strings

public extension Date {
    func formatGermanOmittingTimeIfMidnight() -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: self)

        if components.hour == 0, components.minute == 0 {
            return formatted(.germanDateTimeWithFullMonthOmittingTime)
        } else {
            return formatted(.germanDateTimeWithFullMonth).appending(L10n.News.Molo.Events.Time.appendix)
        }
    }
}
