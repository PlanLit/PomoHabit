//
//  WeeklyCalendarModel.swift
//  PomoHabit
//
//  Created by 원동진 on 2/27/24.
//
import UIKit

import SnapKit

enum HabbitState : Int{
    case done = 0
    case doNot = 1
    case notStart = 2
}

extension HabbitState {
    var backgroundColor : UIColor {
        switch self {
        case .done: 
            return UIColor.pobitRed
        case .doNot:
            return UIColor.pobitStone1
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
