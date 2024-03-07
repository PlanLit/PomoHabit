//
//  TabBarController.swift
//  PomoHabit
//
//  Created by 원동진 on 2/29/24.
//

import UIKit

// MARK: - TabBarController

final class TabBarController: UITabBarController {
    
    // MARK: - Properties
    
    let firstVC = TimerViewController()
    let secondVC = ReportViewController()
    let thirdVC = WeeklyCalendarViewController()
    let fourthVC = MyPageViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBar()
    }
}

// MARK: - Layout Helpers

extension TabBarController {
    private func setTabBar() {
        viewControllers = [firstVC,secondVC,thirdVC,fourthVC]
        tabBar.tintColor = UIColor.pobitRed
        
        firstVC.tabBarItem = UITabBarItem(title: "타이머", image: UIImage(named: "TimerImage"), tag: 1)
        secondVC.tabBarItem = UITabBarItem(title: "습관 달성률", image: UIImage(named: "TargetImageBlack"), tag: 2)
        thirdVC.tabBarItem = UITabBarItem(title: "주간 캘린더", image: UIImage(named: "WeeklyCalendarImage"), tag: 3)
        fourthVC.tabBarItem = UITabBarItem(title: "마이 페이지", image: UIImage(named: "MyPageImage"), tag: 4)
    }
}
