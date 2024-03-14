//
//  TimerModel.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/27.
//

import Combine
import Foundation

enum TimerState {
    /// 진행 전
    case stopped
    /// 진행 중
    case running
    /// 완료
    case finished
}

struct UserData {
    var targetHabit: String
    var targetDate: String
    var alarmTime: Date
    var whiteNoiseType: String
}

// MARK: - TimerModel

final class TimerViewModel: InputOutputProtocol {
    struct Input {
        let memoButtonTapped: PassthroughSubject<Void, Never>
        let whiteNoiseButtonTapped: PassthroughSubject<Void, Never>
        let timerButtonTapped: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let memoButtonAction: AnyPublisher<Void, Never>
        let whiteNoiseButtonAction: AnyPublisher<Void, Never>
        let timerButtonAction: AnyPublisher<Void, Never>
        let timerStateDidChange: AnyPublisher<TimerState, Never>
        let remainingTime: AnyPublisher<TimeInterval, Never>
        let userData: AnyPublisher<UserData, Never>
    }
    
    private let timerStatePublisher = CurrentValueSubject<TimerState, Never>(.stopped)
    private var remainingTimePublisher = CurrentValueSubject<TimeInterval, Never>(0)
    private var cancellables = Set<AnyCancellable>()
    private var timer: AnyCancellable?
    
    private (set) var timerDuration = TimeInterval()
    
    private var targetHabit = String()
    private var targetDate = String()
    private var alarmTime = Date()
    private var whiteNoiseType = String()
    private let currentDate = Date()
    
    init() {
        getUserData()
        getSelectedDayHabitInfo(selectedDay: currentDate)
    }
    
    func transform(input: Input) -> Output {
        let memoAction = input.memoButtonTapped
            .map { print("Memo button tapped") }
            .eraseToAnyPublisher()
        
        let whiteNoiseButtonAction = input.whiteNoiseButtonTapped
            .map { print("White Noise button tapped") }
            .eraseToAnyPublisher()
        
        let timerButtonAction = input.timerButtonTapped
            .map {
                self.handleTimerButtonTapped()
            }
            .eraseToAnyPublisher()
        
        
        let timerStateDidChange = timerStatePublisher.eraseToAnyPublisher()
        let remainingTime = remainingTimePublisher.eraseToAnyPublisher()
        let userDataPublisher = getUserDataPublisher()
        
        return Output(memoButtonAction: memoAction,
                      whiteNoiseButtonAction: whiteNoiseButtonAction,
                      timerButtonAction: timerButtonAction,
                      timerStateDidChange: timerStateDidChange,
                      remainingTime: remainingTime,
                      userData: userDataPublisher
        )
    }
}

// MARK: - HandleTimer

extension TimerViewModel {
    private func handleTimerButtonTapped() {
        switch timerStatePublisher.value {
        case .stopped, .finished:
            startTimer()
        case .running:
            stopTimer()
        }
    }
    
    private func startTimer() {
        timerStatePublisher.send(.running)
        remainingTimePublisher.send(timerDuration) // 타이머 시작 시 남은 시간 설정
        
        timer = Timer.publish(every: 1, on: .main, in: .common) // 1초마다 트리거
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                // 남은 시간 감소
                let newTime = self.remainingTimePublisher.value - 1
                self.remainingTimePublisher.send(newTime)
                
                // 남은 시간이 0이하가 되면 타이머 종료
                if newTime <= 0 {
                    self.timerStatePublisher.send(.finished)
                    self.timer?.cancel() // 타이머 중지
                }
            }
    }
    
    private func stopTimer() {
        //        timer?.cancel()
        //        timerStatePublisher.send(.stopped)
    }
}

// MARK: - CoreData

extension TimerViewModel {
    func getUserData() {
        do {
            let userData = try CoreDataManager.shared.fetchUser()
            guard let targetHabit = userData?.targetHabit,
                  let targetDate = userData?.targetDate,
                  let alarmTime = userData?.alarmTime,
                  let whiteNoiseType = userData?.whiteNoiseType else { return }
            
            self.targetHabit = targetHabit
            self.targetDate = targetDate
            self.alarmTime = alarmTime
            self.whiteNoiseType = whiteNoiseType
        } catch {
            print(error)
        }
    }
    
    private func getSelectedDayHabitInfo(selectedDay: Date) {
        do {
            let selectedHabitInfo = try CoreDataManager.shared.getSelectedHabitInfo(selectedDate: currentDate)
            
            guard let goalTime = selectedHabitInfo?.goalTime else { return } // 목표 시간

            self.timerDuration = TimeInterval(goalTime * 60)
        } catch {
            print(error)
        }
    }
    
    private func getUserDataPublisher() -> AnyPublisher<UserData, Never> {
        return Just(UserData(targetHabit: targetHabit, targetDate: targetDate, alarmTime: alarmTime, whiteNoiseType: whiteNoiseType))
            .eraseToAnyPublisher()
    }
    
    func completedDailyHabit() { // 타이머 완료시 실행되는 메서드
        
        //        CoreDataManager.shared.createDailyHabitInfo(day: date, goalTime: 7, hasDone: true, note: "3번째 날입니다.")
    }
}
