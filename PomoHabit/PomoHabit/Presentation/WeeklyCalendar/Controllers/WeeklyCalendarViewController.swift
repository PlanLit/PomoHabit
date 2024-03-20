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
                let currentDate = Date()
                
                if date.comparisonDate(fromDate: currentDate) == 1 { // 현재 날짜보다 이후일 경우
                    weeklyHabitState.append(.notStart)
                } else {
                    switch dateHabitState{
                    case true:
                        weeklyHabitState.append(.done)
                        
                    case false:
                        weeklyHabitState.append(.doNot)
                        
                    case nil:
                        weeklyHabitState.append(.notStart)
                        
                    case .some(_):
                        break
                    }
                }
            }
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
        let endTime = completedDate.dateToString(format: "hh:mm")
        let startTime = Calendar.current.date(byAdding: .minute, value: -Int(goalTime), to: completedDate)?.dateToString(format: "hh:mm") ?? "00:00"
        
        return startTime + " ~ " + endTime
    }
    
    private func getWeeklyProgress() -> Float {
        return Float(weeklyHabitState.filter{ $0 == .done }.count) / 7.0
    }
    
    private func setSelectedHabitInfo(date: Date) {
        do {
            let currentDate = Date()
            if let selectedHabitInfo = try CoreDataManager.shared.getSelectedHabitInfo(selectedDate: date) { // 습관 진행 날일 경우
                weeklyHabitInfo.note = selectedHabitInfo.note
                
                if date.comparisonDate(fromDate: currentDate) == 1 { // 현재 날짜 보다 이후 일경우
                    weeklyHabitInfo.habitstate = .notStart
                    weeklyHabitInfo.goalTime = selectedHabitInfo.goalTime
                    weeklyHabitInfo.duringTime = "00:00 ~ 00:00"
                } else { // 현재 날짜 포함 이전일 경우
                    weeklyHabitInfo.habitstate = selectedHabitInfo.hasDone ?  HabitState.done : HabitState.doNot
                    weeklyHabitInfo.goalTime = selectedHabitInfo.goalTime
                    weeklyHabitInfo.duringTime = getDuringTime(completedDate: date, goalTime: selectedHabitInfo.goalTime)
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
