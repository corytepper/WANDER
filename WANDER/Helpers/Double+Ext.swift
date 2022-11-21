//
//  Double+Ext.swift
//  WANDER
//
//  Created by Cory Tepper on 11/21/22.
//

import Foundation

extension Double {
    func meterToMiles() -> Double {
        let meters = Measurement(value: self, unit: UnitLength.meters)
        return meters.converted(to: .miles).value
    }
    
    func toString(places: Int) -> String {
        return String(format: "%.\(places)f", self)
    }
}
