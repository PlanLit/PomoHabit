//
//  WeeklyCalendarVIewModel.swift
//  PomoHabit
//
//  Created by 원동진 on 6/19/24.
//

import Combine
import Foundation

// MARK: - WeeklyCalendarViewController

class WeeklyCalendarViewModel: ObservableObject {
    private let coreDataManager: CoreDataManagerProtocol
    
    // MARK: - Properties
    
    private var targetHabit = String()
    @Published private(set) var weeklyDates: [Date] = []
    @Published private(set) var weeklyHabitState: [HabitState] = []
    @Published private(set) var weeklyHabitInfo: WeeklyHabitInfoModel?
    
    init(coreDataManager: CoreDataManagerProtocol) {
        self.coreDataManager = coreDataManager
        
        getTargetHabit()
        getTodayHabitInfo()
        getWeeklyData()
        getWeeklyHabitState()
    }
}

// MARK: - HandleDuringTime

extension WeeklyCalendarViewModel {
    private func getDuringTime(completedDate: Date, goalTime: Int16)-> String {
        let endTime = completedDate.dateToString(format: "HH:mm")
        
        let startTime = Calendar.current.date(byAdding: .minute, value: -Int(goalTime), to: completedDate)?.dateToString(format: "HH:mm") ?? "00:00"
        
        return startTime + " ~ " + endTime
    }
}

// MARK: - HandleWeeklyDates

extension WeeklyCalendarViewModel {
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
        
        self.weeklyDates = getWeeklyDates
    }
}

// MARK: - HandleWeeklyHabitStates

extension WeeklyCalendarViewModel {
    private func getWeeklyHabitState() {
        do {
            var getWeeklyHabitState: [HabitState] = []
            for date in weeklyDates {
                let dateHabitState = try coreDataManager.getSelectedHabitInfo(selectedDate: date).map{ $0.hasDone }
                
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
            self.weeklyHabitState = getWeeklyHabitState
        } catch {
            print(error)
        }
    }
}


// MARK: - CoreData - TodayHabitInfo

extension WeeklyCalendarViewModel {
    private func getTargetHabit() {
        do {
            let userInfo = try coreDataManager.fetchUser()
            
            self.targetHabit = userInfo?.targetHabit ?? "습관 이름"
        } catch {
            print(error)
        }
    }
    
    private func getTodayHabitInfo() {
        do {
            let todayHabitInfo = try coreDataManager.getSelectedHabitInfo(selectedDate: Date())
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
            self.weeklyHabitInfo = WeeklyHabitInfoModel(
                targetHabit: targetHabit,
                habitstate: todayHabitState,
                goalTime: goalTime,
                duringTime: duringTime,
                note: todayHabitInfo?.note)
            
        } catch {
            print(error)
        }
    }
}
