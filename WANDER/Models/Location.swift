//
//  Location.swift
//  WANDER
//
//  Created by Cory Tepper on 11/22/22.
//

import Foundation
import RealmSwift

final class Location: Object {
    @objc dynamic public private(set) var latitude = 0.0
    @objc dynamic public private(set) var longitude = 0.0
    
    convenience init(lat: Double, long: Double) {
        self.init()
        self.latitude = lat
        self.longitude = long
    }
    
}
