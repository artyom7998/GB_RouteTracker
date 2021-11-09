//
//  CoordinatePath.swift
//  RouteTracker
//
//  Created by Артем Зарудный on 06.11.2021.
//

import Foundation
import RealmSwift

class CoordinatePath: Object {

    @objc dynamic var id = 0
    @objc dynamic var lat: Double = 0.0
    @objc dynamic var lon: Double = 0.0
    
    override static func primaryKey() -> String? {
        return "id"
    }

    convenience init(_ id: Int, _ lat: Double, _ lon: Double) {
        self.init()
        self.id = id
        self.lat = lat
        self.lon = lon
    }
}
