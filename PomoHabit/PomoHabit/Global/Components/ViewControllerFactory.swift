//
//  ViewControllerFactory.swift
//  PomoHabit
//
//  Created by 원동진 on 3/25/24.
//

import Foundation
class ViewControllerFactory {
    static func makeWeeklyCalendarViewController() -> WeeklyCalendarViewController {
        let viewController = WeeklyCalendarViewController(weeklyHabitInfo: WeeklyHabitInfoModel())
        
        return viewController
    }
}
