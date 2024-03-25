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
    private var weeklyHabitInfo: WeeklyHabitInfoModel
    
    // MARK: - Views
    
    private lazy var weeklyCalendarView: WeeklyCalendarView = {
        let view = WeeklyCalendarView()
        view.dateDelegate = self

        return view
    }()
    
    // MARK: - init
    init(weeklyHabitInfo: WeeklyHabitInfoModel) {
        self.weeklyHabitInfo = weeklyHabitInfo
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        
        view = weeklyCalendarView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getWeeklyData()
        setWeeklyCalendView()
        getTargetHabit()
        getWeeklyHabitState()
        setWeeklyHabiState()
        getTodayHabitInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        weeklyCalendarView.moveToSelectedCell(weeklyDates: weeklyDates)
    }
    
    override func viewDidLayoutSubviews() { // 해당 메소드 안에서만 오토레이 아웃으로 설정된 UI/View의 Frame 사이즈를 알 수 있음
        super.viewDidLayoutSubviews()
        
        setUpWeeklyHabbitProgressView(progress: getWeeklyProgress())
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
        if progress != 0 {
            let weeklyCalendarViewWidth = weeklyCalendarView.frame.width
            let progressCircleOffset = Int(weeklyCalendarViewWidth * CGFloat(progress)) + 5
            
            weeklyCalendarView.setProgressCircleImg(offset: progressCircleOffset)
            weeklyCalendarView.setWeeklyHabitProgressView(progress: progress)
        }
    }
}

// MARK: - Data 관련 method

extension WeeklyCalendarViewController {
    private func getWeeklyData() {
        var getWeeklyDates : [Date] = []
        let calendar = Calendar.current
        
        // MARK: - 현재 주의 시작 날짜
        
        guard let startDate = calendar.dateInterval(of: .weekOfYear, for: Date())?.start else { return }
        
        // 주간 캘린더를 월요일부터 시작하기
        
        guard let mondayDate = calendar.date(byAdding: .day, value: 1, to: startDate) else { return }
        
        // MARK: - 주간 데이터 구하기
        
        for i in 0...6 {
            guard let date = calendar.date(byAdding: .day, value: i, to: mondayDate) else { return }
            getWeeklyDates.append(date)
        }
        
        weeklyDates = getWeeklyDates
    }
    
    private func getWeeklyHabitState() {
        do {
            var getWeeklyHabitState: [HabitState] = []
            for date in weeklyDates {
                let dateHabitState = try CoreDataManager.shared.getSelectedHabitInfo(selectedDate: date).map{$0.hasDone}
                let currentDate = Date()
                
                if date.comparisonDate(fromDate: currentDate) == 1 { // 현재 날짜보다 이후 날짜일 경우
                    if dateHabitState == false {
                        getWeeklyHabitState.append(.notStart)
                    } else {
                        getWeeklyHabitState.append(.dayOff)
                    }
                } else if date.comparisonDate(fromDate: currentDate) == 0 { // 오늘
                    switch dateHabitState {
                    case true:
                        getWeeklyHabitState.append(.done)
                        
                    case false:
                        getWeeklyHabitState.append(.notStart)
                        
                    case nil:
                        getWeeklyHabitState.append(.dayOff)
                        
                    case .some(_):
                        break
                    }
                } else {
                    switch dateHabitState { // 오늘보다 이전
                    case true:
                        getWeeklyHabitState.append(.done)
                        
                    case false:
                        getWeeklyHabitState.append(.doNot)
                        
                    case nil:
                        getWeeklyHabitState.append(.dayOff)
                        
                    case .some(_):
                        break
                    }
                }
            }
            weeklyHabitState = getWeeklyHabitState
        } catch {
            print(error)
        }
    }
    
    private func getTargetHabit() {
        do {
            let userInfo = try CoreDataManager.shared.fetchUser()
            
            weeklyHabitInfo.targetHabit = userInfo?.targetHabit ?? "습관 이름"
        } catch {
            print(error)
        }
    }
    
    private func getDuringTime(completedDate: Date, goalTime: Int16)-> String {
        let endTime = completedDate.dateToString(format: "HH:mm")

        let startTime = Calendar.current.date(byAdding: .minute, value: -Int(goalTime), to: completedDate)?.dateToString(format: "HH:mm") ?? "00:00"
        
        return startTime + " ~ " + endTime
    }
    
    private func getWeeklyProgress() -> Float {
        return Float(weeklyHabitState.filter{ $0 == .done }.count) / 7.0
    }
    
    private func getTodayHabitInfo() {
        do {
            let todayHabitInfo = try CoreDataManager.shared.getSelectedHabitInfo(selectedDate: Date())
            var todayHabitState : HabitState = .notStart
            var duringTime: String = ""
            var goalTime: Int16 = todayHabitInfo?.goalTime ?? 0
        
            switch todayHabitInfo?.hasDone {
            case true:
                todayHabitState = .done
                duringTime = getDuringTime(completedDate: todayHabitInfo?.date ?? Date(), goalTime: todayHabitInfo?.goalTime ?? 0)
                
            case false:
                todayHabitState = .notStart
                duringTime = "00:00 ~ 00:00"
                
            case nil:
                todayHabitState = .dayOff
                duringTime = "쉬는 날"
                goalTime = 0
                
            case .some(_):
                break
            }
            
            weeklyCalendarView.setHabitInfoView(state: todayHabitState, targetHabit: weeklyHabitInfo.targetHabit ?? "목표 습관", duringTime: duringTime, goalTime: goalTime)
            weeklyCalendarView.setNoteContentLabel(note: todayHabitInfo?.note ?? "메모")
        } catch {
            print(error)
        }
    }
    
    private func setSelectedHabitInfo(date: Date) {
        do {
            let currentDate = Date()
            if let selectedHabitInfo = try CoreDataManager.shared.getSelectedHabitInfo(selectedDate: date) { // 습관 진행 날일 경우
                weeklyHabitInfo.note = selectedHabitInfo.note
                
                if date.comparisonDate(fromDate: currentDate) == 1 { // 현재 날짜 포함 이전일 경우
                    weeklyHabitInfo.habitstate = .notStart
                    weeklyHabitInfo.goalTime = selectedHabitInfo.goalTime
                    weeklyHabitInfo.duringTime = "00:00 ~ 00:00"
                    
                } else { // 현재 날짜 보다 이후 일경우
                    weeklyHabitInfo.habitstate = selectedHabitInfo.hasDone ?  HabitState.done : HabitState.doNot
                    weeklyHabitInfo.goalTime = selectedHabitInfo.goalTime
                    if selectedHabitInfo.hasDone {
                        print(date.dateToString(format: "yyyy-MM-dd HH:mm"))
                        weeklyHabitInfo.duringTime = getDuringTime(completedDate: date, goalTime: selectedHabitInfo.goalTime)
                    } else {
                        weeklyHabitInfo.duringTime = "00:00 ~ 00:00"
                    }
                }
            } else { // 습관 진행 날이 아닐경우
                weeklyHabitInfo.habitstate = .notStart
                weeklyHabitInfo.goalTime = 0
                weeklyHabitInfo.duringTime = "쉬는 날"
                weeklyHabitInfo.note = "쉬는 날/습관 시작하기 전날"
            }
        } catch {
            print(error)
        }
    }
}

// MARK: - Delegate

extension WeeklyCalendarViewController: SendSelectedData {
    func sendDate(date: Date, completion: @escaping (WeeklyHabitInfoModel) -> Void) {
        setSelectedHabitInfo(date: date)
        completion(weeklyHabitInfo)
    }
}




