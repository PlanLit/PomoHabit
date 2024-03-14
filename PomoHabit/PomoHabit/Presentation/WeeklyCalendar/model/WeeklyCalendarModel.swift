//
//  WeeklyCalendarModel.swift
//  PomoHabit
//
//  Created by 원동진 on 2/27/24.
//
import UIKit

import SnapKit

enum HabitState{
    case done
    case doNot
    case notStart
}

extension HabitState {
    var backgroundColor : UIColor {
        switch self {
        case .done: 
            return .pobitRed
        case .doNot:
            return .pobitStone1
        case .notStart:
            return .white
        }
    }
    
    var image : UIImage {
        switch self {
        case .done:
            return UIImage(named: "DoneImage") ?? UIImage(systemName: "smiley.fill")!
        case .doNot:
            return UIImage(named: "DoNotImage") ?? UIImage(systemName: "smiley.fill")!
        case .notStart:
            return UIImage(named: "NotStartImage") ?? UIImage(systemName: "smiley.fill")!
        }
    }
}
