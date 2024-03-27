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
    
    let firstVC = ViewControllerFactory.makeTimerViewController()
    let secondVC = ReportViewController()
    let thirdVC = ViewControllerFactory.makeWeeklyCalendarViewController()
    let fourthVC = ViewControllerFactory.makeMypageViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBar()
        adjustTabBarIconPositionBasedOnDevice()
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
    
    private func adjustTabBarItemPosition(yOffset: CGFloat) {
        guard let items = self.tabBar.items else { return }
        
        for item in items {
            // 이미지 인셋 조정으로 인한 아이템의 위치 변경
            item.imageInsets = UIEdgeInsets(top: yOffset, left: 0, bottom: -yOffset, right: 0)
            // 타이틀 위치 조정
            item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: yOffset)
        }
    }
    
    private func adjustTabBarIconPositionBasedOnDevice() {
        let hasNotch = view.hasNotch
        let yOffset: CGFloat = hasNotch ? 8 : -4
        
        adjustTabBarItemPosition(yOffset: yOffset)
    }
}
