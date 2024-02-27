//
//  Date+Extension.swift
//  PomoHabit
//
//  Created by 원동진 on 2/27/24.
//

import Foundation
extension Date {
    func monthAndDaytoString(format : String = "MM.dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
