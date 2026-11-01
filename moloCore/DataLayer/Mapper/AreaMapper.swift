//
//  AreaMapper.swift
//  DataLayer
//

import Domain
import Foundation

public extension Components.Schemas.Area {
    func toArea() -> Domain.Area {
        Area(
            id: id ?? 0,
            name: name,
            longitude: longitude ?? "",
            latitude: latitude ?? ""
        )
    }
}

public extension Components.Schemas.Areas {
    func toArea() -> Domain.Area {
        Area(
            id: id ?? 0,
            name: name,
            longitude: "",
            latitude: ""
        )
    }
}
