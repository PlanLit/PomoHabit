//
//  ViewControllerFactory.swift
//  PomoHabit
//
//  Created by 원동진 on 3/25/24.
//

// MARK: - ViewControllerFactory

final class ViewControllerFactory {
    static func makeTimerViewController() -> TimerViewController {
        let viewController = TimerViewController(viewModel: TimerViewModel(), rootView: TimerView())
        
        return viewController
    }
    
    static func makeWeeklyCalendarViewController() -> WeeklyCalendarViewController {
        let viewController = WeeklyCalendarViewController(weeklyHabitInfo: WeeklyHabitInfoModel())
        
        return viewController
    }
}
