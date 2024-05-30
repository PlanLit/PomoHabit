//
//  ViewControllerFactory.swift
//  PomoHabit
//
//  Created by 원동진 on 3/25/24.
//

// MARK: - ViewControllerFactory

final class ViewControllerFactory {
    static func makeTimerViewController() -> TimerViewController {
        let viewController = TimerViewController(viewModel: TimerViewModel(coreDataManager: CoreDataManager.shared, userDefaultsManager: UserDefaultsManager.shared), rootView: TimerView())
        
        return viewController
    }
    
    static func makeWeeklyCalendarViewController() -> WeeklyCalendarViewController {
        let viewController = WeeklyCalendarViewController(weeklyHabitInfo: WeeklyHabitInfoModel(), coreDataManager: CoreDataManager.shared)
        
        return viewController
    }
    
    static func makeMypageViewController() -> MyPageViewController {
        let viewController = MyPageViewController(openSourceViewController: OpenSourceViewController(), customerServiceViewController: CustomerServiceViewController(), nicknameViewController: NicknameViewController())
        
        return viewController
    }
}
