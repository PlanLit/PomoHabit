//
//  WeeklyCalendarViewController.swift
//  PomoHabit
//
//  Created by 원동진 on 2/27/24.
//

import UIKit

import SnapKit

// MARK: - WeeklyCalendarViewController

final class WeeklyCalendarViewController: BaseViewController {
    
    // MARK: - Properties
    
    var year : Int = 0
    var month : Int = 0
    
    private lazy var weeklyCalendarView : WeeklyCalendarView = {
        let view = WeeklyCalendarView()
        view.dateDelegate = self
        
        return view
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setWeeklyData()
        setAddSubViews()
        setSetAutoLayout()
    }
    
    override func viewDidLayoutSubviews() { // 해당 메소드 안에서만 오토레이 아웃으로 설정된 UI/View의 Frame 사이즈를 알 수 있음
        super.viewDidLayoutSubviews()
        do {
            let weeklyHasDoneCount = try CoreDataManager.shared.fetchDailyHabitInfos().filter{ $0.hasDone == true }.count
            
            setUpWeeklyHabbitProgressView(progress: Float(weeklyHasDoneCount) / 7.0)
        } catch {
            print(error)
        }
        
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
    private func setUpWeeklyHabbitProgressView(progress : Float) {
        let weeklyCalendarViewWidth = weeklyCalendarView.frame.width
        let progressCircleOffset = Int(weeklyCalendarViewWidth * CGFloat(progress)) - 5
        
        weeklyCalendarView.setProgressCircleImg(offset: progressCircleOffset)
        weeklyCalendarView.setWeeklyHabitProgressView(progress: progress)
    }
    
    private func setUPWeeklyHabbitInfoView(state: HabitState, targetHabit: String, duringTime: String, goalTime: String, note: String) {
        weeklyCalendarView.setHabitInfoView(state: state, targetHabit: targetHabit, duringTime: duringTime, goalTime: goalTime)
        weeklyCalendarView.setNoteContentLabel(note: note)
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
        guard let thisYer = components.year else { return }
        guard let thisMonth = components.month else { return }
        
        year = thisYer
        month = thisMonth
        
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
            let habitInfos = try CoreDataManager.shared.fetchDailyHabitInfos() // Daily 습관 정보 배열
            let userInfo = try CoreDataManager.shared.fetchUser() // 유저 정보
            let habitInfoDays = habitInfos.compactMap{$0.day} // Daily 습관 날짜 정보 배열
            guard let targetHabit = userInfo?.targetHabit else { return } // 설정한 습관
            var dateStr = Date().dateToString(format: "yyyy-MM-dd") // 앞에 년도를 붙여주기 위함
            
            guard let startTime = userInfo?.startTime else { return } // 습관 시작 시간
            dateStr += " " + startTime
            guard let startTimeTypeDate = dateStr.getStringToDate(format: "yyyy-MM-dd HH:mm") else { return }
            
            if let index = habitInfoDays.firstIndex(where: { $0 == selectedDay }) { // 선택한 날짜에 대한 습관 정보
                let selectedHabitInfo = habitInfos[index]
                let goalTime = selectedHabitInfo.goalTime
                let hasDone = selectedHabitInfo.hasDone ? HabitState.done : HabitState.doNot
                guard let note = selectedHabitInfo.note else { return }
                guard let endTime = Calendar.current.date(byAdding: .minute, value: Int(goalTime), to: startTimeTypeDate) else { return }
                let duringTime = startTimeTypeDate.dateToString(format: "HH:mm") + "~" + endTime.dateToString(format: "HH:mm")
                
                setUPWeeklyHabbitInfoView(state: hasDone, targetHabit: targetHabit, duringTime: duringTime, goalTime: "\(goalTime)", note: note)
            } else {
                setUPWeeklyHabbitInfoView(state: .doNot, targetHabit: "습관 이름", duringTime: "00:00~00:00", goalTime: "0", note: "시작하지 않은 습관입니다.")
            }
        } catch {
            print(error)
        }
    }
}

// MARK: - Delegate

extension WeeklyCalendarViewController: SendSelectedData{
    func sendDate(date: Int) {
        var dateStr = String(year)
        
        dateStr += month < 10 ? "-0\(month)" : "-\(month)"
        dateStr += date < 10 ? "-0\(date)" : "-\(date)"
        
        getSelectedDayHabitInfo(selectedDay: dateStr)
    }
    
}
