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
    
    private var weeklyDates: [Date] = []
    private var weeklyHabitState: [HabitState] = []
    private var totalHabitInfo: TotalHabitInfo?
    private var targetHabit: String?
    private var habitstate: HabitState = .notStart
    private var goalTime: Int16 = 0
    private var duringTime: String = ""
    
    // MARK: - Views
    
    private lazy var weeklyCalendarView: WeeklyCalendarView = {
        let view = WeeklyCalendarView()
        view.dateDelegate = self
        
        return view
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getWeeklyData()
        getTargetHabit()
        getWeeklyHabitState()
        
        setWeeklyCalendView()
        setWeeklyHabiState()
        setAddSubViews()
        setSetAutoLayout()
    }
    
    override func viewDidLayoutSubviews() { // 해당 메소드 안에서만 오토레이 아웃으로 설정된 UI/View의 Frame 사이즈를 알 수 있음
        super.viewDidLayoutSubviews()
        
        setUpWeeklyHabbitProgressView(progress: getWeeklyProgress())
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

// MARK: - View 관련 Methods

extension WeeklyCalendarViewController {
    private func setWeeklyCalendView() {
        weeklyCalendarView.setWeeklyDates(weeklyDates: weeklyDates)
    }
    
    private func setWeeklyHabiState() {
        weeklyCalendarView.setWeeklyHabitState(setData: weeklyHabitState)
    }
    
    private func setUpWeeklyHabbitProgressView(progress : Float) {
        let weeklyCalendarViewWidth = weeklyCalendarView.frame.width
        let progressCircleOffset = Int(weeklyCalendarViewWidth * CGFloat(progress)) - 15
        
        weeklyCalendarView.setProgressCircleImg(offset: progressCircleOffset)
        weeklyCalendarView.setWeeklyHabitProgressView(progress: progress)
    }
    
    private func setSelectedHabitInfo() {
        if totalHabitInfo == nil { // 쉬는날 or 습관 시작하기 전날
            weeklyCalendarView.setHabitInfoView(state: .notStart, targetHabit: targetHabit ?? "설정한 습관", duringTime: "00:00 ~ 00:00", goalTime: 0)
            weeklyCalendarView.setNoteContentLabel(note: "쉬는날 또는 습관 시작 하기 전날입니다.")
        } else {
            weeklyCalendarView.setHabitInfoView(state: habitstate, targetHabit: targetHabit ?? "설정한 습관", duringTime: duringTime, goalTime: goalTime)
            weeklyCalendarView.setNoteContentLabel(note: totalHabitInfo?.note ?? "")
        }
    }
}

// MARK: - Data 관련 method

extension WeeklyCalendarViewController {
    private func getWeeklyData() {
        let calendar = Calendar.current
        
        // MARK: - 현재 주의 시작 날짜
        
        guard let startDate = calendar.dateInterval(of: .weekOfYear, for: Date())?.start else { return }
        
        // 주간 캘린더를 월요일부터 시작하기
        
        guard let mondayDate = calendar.date(byAdding: .day, value: 1, to: startDate) else { return }
        
        // MARK: - 주간 데이터 구하기
        
        for i in 0...6 {
            guard let date = calendar.date(byAdding: .day, value: i, to: mondayDate) else { return }
            weeklyDates.append(date)
        }
    }
    
    private func getWeeklyHabitState() {
        do {
            for date in weeklyDates {
                let dateHabitState = try CoreDataManager.shared.getSelectedHabitInfo(selectedDate: date).map{$0.hasDone}
                
                switch dateHabitState{
                case nil:
                    weeklyHabitState.append(.notStart)
                case true:
                    weeklyHabitState.append(.done)
                case false:
                    weeklyHabitState.append(.doNot)
                case .some(_):
                    break
                }
            }
        } catch {
            print(error)
        }
    }
    
    private func getTargetHabit() {
        do {
            let userInfo = try CoreDataManager.shared.fetchUser()
            targetHabit = userInfo?.targetHabit
        } catch {
            print(error)
        }
    }
    
    private func getDuringTime(completedDate: Date, goalTime: Int16)-> String {
        let endTime = completedDate.dateToString(format: "hh:mm")
        let startTime = Calendar.current.date(byAdding: .minute, value: -Int(goalTime), to: completedDate)?.dateToString(format: "hh:mm") ?? "00:00"
        
        return startTime + " ~ " + endTime
    }
    
    private func getWeeklyProgress() -> Float {
        return Float(weeklyHabitState.filter{ $0 == .done }.count) / 7.0
    }
    
    private func getWeeklyHabitInfo(date : Date) {
        do {
            totalHabitInfo = try CoreDataManager.shared.getSelectedHabitInfo(selectedDate: date) // 선택한 습관 정보
        } catch {
            print(error)
        }
        
    }
    
    private func getHabitstate() {
        guard let habitState = totalHabitInfo?.hasDone else { return } // 습관 진행 현황
        habitstate = habitState ? HabitState.done : HabitState.doNot // treu : false 처리
    }
    
    private func getGoalTime() {
        guard let goalTimeData = totalHabitInfo?.goalTime else { return } // 목표 시간
        goalTime = goalTimeData
    }
    
    private func getDuringTime() {
        duringTime = getDuringTime(completedDate: totalHabitInfo?.date ?? Date(), goalTime: goalTime) // 습관 진행 기간
        
        if habitstate == .doNot || habitstate == .notStart {
            duringTime = "00:00 ~ 00:00"
        }
    }
}

// MARK: - Delegate

extension WeeklyCalendarViewController: SendSelectedData {
    func sendDate(date: Date) { // 선택한 셀의 날짜
        getWeeklyHabitInfo(date: date)
        getHabitstate()
        getDuringTime()
        getGoalTime()
        getDuringTime()
        setSelectedHabitInfo()
    }
}
