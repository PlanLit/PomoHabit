//
//  TimerViewController.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/27.
//

import UIKit

// MARK: - TimerViewController

final class TimerViewController: BaseViewController {
    
    // MARK: - Properties
    
    private var rootView = TimerView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension TimerViewController {
    func getUserData() {
        do {
            let userData = try CoreDataManager.shared.fetchUser()
            guard let nickName = userData?.nickName else { return } // 닉네임
            guard let targetHabit = userData?.targetHabit else { return } // 할 습관
            guard let targetDate = userData?.targetDate else { return } // 습관을 진행할 요일
            guard let startTime = userData?.startTime else { return } // 습관 진행 시간
            guard let whiteNoiseType = userData?.whiteNoiseType else { return } // 사운드
            
        } catch {
            print(error)
        }
    }
    
    func completedTodayHabit() {
        let date = Date().dateToString(format: "yyyy-MM-dd")

        CoreDataManager.shared.createDailyHabitInfo(day: date, goalTime: 7, hasDone: true, note: "3번째 날입니다.")
    }
}
