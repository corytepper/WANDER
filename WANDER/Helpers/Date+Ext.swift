//
//  Date+Ext.swift
//  WANDER
//
//  Created by Cory Tepper on 11/22/22.
//

import Foundation

extension Date {
    func getDateString() -> String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self)
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        
        return "\(month)/\(day)/\(year)"
    }
}
