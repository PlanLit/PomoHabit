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
    var weeklyDates: [Date] = []
    
    // MARK: - Properties
    
    private lazy var weeklyCalendarView: WeeklyCalendarView = {
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
        getWeeklyHabitState()
    }
    
    override func viewDidLayoutSubviews() { // 해당 메소드 안에서만 오토레이 아웃으로 설정된 UI/View의 Frame 사이즈를 알 수 있음
        super.viewDidLayoutSubviews()
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
    
    func setUPWeeklyHabbitInfoView(state: HabitState, targetHabit: String, duringTime: String, goalTime: String, note: String) {
        weeklyCalendarView.setHabitInfoView(state: state, targetHabit: targetHabit, duringTime: duringTime, goalTime: goalTime)
        weeklyCalendarView.setNoteContentLabel(note: note)
    }
}

// MARK: - Get 주간 데이터

extension WeeklyCalendarViewController {
    private func setWeeklyData() {
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

        weeklyCalendarView.setWeeklyDates(weeklyDates: weeklyDates)
    }
    
    private func getWeeklyHabitState() {
        var weeklyHabitState: [HabitState] = []
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
            
            weeklyCalendarView.setWeeklyHabitState(setData: weeklyHabitState)
        } catch {
            print(error)
        }
    }
}

// MARK: - Delegate

extension WeeklyCalendarViewController: SendSelectedData{
    func sendDate(date: Date) { // 선택한 셀의 날짜
   
    }
}
