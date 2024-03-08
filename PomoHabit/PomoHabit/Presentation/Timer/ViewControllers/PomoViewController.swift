//
//  TimerViewController.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/27.
//

import Combine
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
            guard let nickName = userData?.nickname else { return } // 닉네임
            guard let targetHabit = userData?.targetHabit else { return } // 할 습관
            guard let targetDate = userData?.targetDate else { return } // 습관을 진행할 요일
            guard let startTime = userData?.startTime else { return } // 습관 진행 시간
            guard let whiteNoiseType = userData?.whiteNoiseType else { return } // 사운드
        } catch {
            print(error)
        }
    }
    
    func completedTodayHabit() { // 타이머 완료시 실행되는 함수입니다. 아래에 코드를 활용하시면 됩니다.
        let currentDate = Date() // 테스트할때 사용하시고 지워주시면 됩니다.
        let date = Date().dateToString(format: "yyyy-MM-dd")
        let changeDate = Calendar.current.date(byAdding: .day,value: 1, to: currentDate)?.dateToString(format: "yyyy-MM-dd") // 오늘 날짜 기준으로 +,- 할수 있 습니다 .테스트할때 사용하시고 지워 주시면 됩니다.
        
        CoreDataManager.shared.createDailyHabitInfo(day: date, goalTime: 7, hasDone: true, note: "3번째 날입니다.")
    }
}
