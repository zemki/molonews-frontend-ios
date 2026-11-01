//
//  EventOccurence.swift
//  moloCore
//

import Domain
import Foundation

extension Components.Schemas.EventOccurrence {
    func toEventOccurrence() -> EventOccurrence {
        EventOccurrence(
            startDate: startDatetime,
            endDate: endDatetime
        )
    }
}
