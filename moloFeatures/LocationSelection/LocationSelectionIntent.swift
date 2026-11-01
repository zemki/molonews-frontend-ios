//
//  LocationSelectionIntent.swift
//  LocationSelection
//

import Domain
import Foundation

enum LocationSelectionIntent {
    case willAppear
    case onStartSearch(locationName: String)
    case onClickLocate
    case onChangeRadius(radius: Double)
    case onClickDone(closeAction: (() -> Void)?)
    case onClickPostingLocationSelected(location: PostingLocation)
}
