//
//  ViewControllerFactory.swift
//  PomoHabit
//
//  Created by 원동진 on 3/25/24.
//

// MARK: - ViewControllerFactory

class ViewControllerFactory {
    static func makeWeeklyCalendarViewController() -> WeeklyCalendarViewController {
        let viewController = WeeklyCalendarViewController(weeklyHabitInfo: WeeklyHabitInfoModel())
        
        return viewController
    }
    
    static func makeMypageViewController() -> MyPageViewController {
        let viewController = MyPageViewController(openSourceViewController: OpenSourceViewController(), customerServiceViewController: CustomerServiceViewController(), nicknameViewController: NicknameViewController())
        
        return viewController
    }
}
