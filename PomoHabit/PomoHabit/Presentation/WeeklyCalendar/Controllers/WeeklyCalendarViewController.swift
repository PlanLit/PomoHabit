//
//  WeeklyCalendarViewController.swift
//  PomoHabit
//
//  Created by 원동진 on 2/27/24.
//

import UIKit

import SnapKit

// MARK: - WeeklyCalendarViewController

class WeeklyCalendarViewController: BaseViewController {
    
    // MARK: - Properties
    
    private lazy var weeklyCalendarView = WeeklyCalendarView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setWeeklyData()
        setAddSubViews()
        setSetAutoLayout()
    }
    
    override func viewDidLayoutSubviews() { // 해당 메소드 안에서만 오토레이 아웃으로 설정된 UI/View의 Frame 사이즈를 알 수 있음
        super.viewDidLayoutSubviews()
        
        setUpWeeklyHabbitProgressView(progress: 0.6)
    }
}

// MARK: - Layout Helpers

extension WeeklyCalendarViewController {
    private func setAddSubViews() {
        view.addSubview(weeklyCalendarView)
    }
    
    private func setSetAutoLayout() {
        weeklyCalendarView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(LayoutLiterals.minimumHorizontalSpacing)
        }
    }
}

// MARK: - Action Helpers

extension WeeklyCalendarViewController {
    @objc private func name() {
        
    }
}

// MARK: - Methods

extension WeeklyCalendarViewController {
    private func setUpWeeklyHabbitProgressView(progress : Float){
        let weeklyCalendarViewWidth = weeklyCalendarView.frame.width
        let progressCircleOffset = Int(weeklyCalendarViewWidth * CGFloat(progress)) - 5
        
        weeklyCalendarView.setProgressCircleImg(offset: progressCircleOffset)
        weeklyCalendarView.setWeeklyHabbitProgressView(progress: progress)
    }
}

// MARK: - Get 주간 데이터

extension WeeklyCalendarViewController {
    private func setWeeklyData() {
        var weeklyDates : [Int] = []
        let calendar = Calendar.current
        
        // MARK: - 현재 주의 시작 날짜
        
        guard let result = calendar.dateInterval(of: .weekOfYear, for: Date()) else { return } // 현재 날짜가 속해 있는 주의 첫번째/마지막 날짜
        guard let weeklyStartDate = calendar.date(byAdding: .day, value: 1, to: result.start)?.dateToString(format: "dd") else { return }
        
        // MARK: - 현재 주의 마지막 날짜
        
        let components = calendar.dateComponents([.year, .month], from: Date()) // 현재 날짜의 년도와 월
        guard let currentStartDate = calendar.date(from: components) else { return } // 날짜와 년도를 가지고 가장 첫번째 날짜 Get
        guard let nextStartDate = calendar.date(byAdding: .month, value: 1, to: currentStartDate) else {return} // 다음 달의 가장 첫번쨰날
        guard let currentEndDate = calendar.date(byAdding: .day, value: -1, to: nextStartDate)?.dateToString(format: "dd") else {return} // 다음달의 가장 첫번째날 이전날 = 이번달의 마지막날
        
        // MARK: - 주간 데이터 구하기
        
        guard let weeklyStartDateInt = Int(weeklyStartDate) else { return }
        guard let currentEndDateInt = Int(currentEndDate) else { return }
        
        for i in 0...6 {
            let date = weeklyStartDateInt + i
            
            if date <= currentEndDateInt {
                weeklyDates.append(date)
            } else {
                weeklyDates.append(date - currentEndDateInt)
            }
        }
        
        weeklyCalendarView.setWeeklyDates(weeklyDates: weeklyDates)
    }
    
    func getSelectedDayHabitInfo(selectedDay : String) {
        do {
            let habitInfos = try CoreDataManager.shared.fetchDailyHabitInfos()
            let habitInfoDays = habitInfos.map{$0.day!}
            if let index = habitInfoDays.firstIndex(where: {$0 == selectedDay}) {
                let selectedHabitInfo = habitInfos[index]
                guard let day = selectedHabitInfo.day else { return }
                let goalTime = selectedHabitInfo.goalTime
                let hasDone = selectedHabitInfo.hasDone
                guard let note = selectedHabitInfo.note else { return }
                print("day :\(day),goalTime:\(goalTime),hasDone:\(hasDone),note:\(note)")
            }
        }catch {
            print(error)
        }
    }
}


