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
    /// 타이머 종료
    case finished
    /// 완료
    case done
}

struct UserData {
    var targetHabit: String
    var targetDate: String
    var alarmTime: String
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
    private lazy var remainingTimePublisher = CurrentValueSubject<TimeInterval, Never>(self.timerDuration)
    private var cancellables = Set<AnyCancellable>()
    private var timer: AnyCancellable?
    
    private (set) var timerDuration = TimeInterval()
    
    private var targetHabit = String()
    private var targetDate = String()
    private var alarmTime = String()
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
        case .stopped:
            startTimer()
        case .running:
            break
        case .finished:
            recordCompletedHabit()
        case .done:
            handleDoneStatus()
        }
    }
    
    private func startTimer() {
        timerStatePublisher.send(.running)
        remainingTimePublisher.value = 0
        
        timer = Timer.publish(every: 1, on: .main, in: .common)
        // 구독이 시작되는 즉시 타이머를 활성화
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                let newTime = self.remainingTimePublisher.value + 1
                self.remainingTimePublisher.send(newTime)
                
                // 목표시간에 도달하면 타이머 종료
                if newTime >= self.timerDuration {
                    print(timerStatePublisher.value)
                    self.timer?.cancel()
                    self.timerStatePublisher.send(.finished)
                }
            }
    }
    
    private func handleDoneStatus() {
        timerStatePublisher.send(.done)
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
            
            let alarmTimeString = Date().extractTimeFromDate(alarmTime)
            
            self.targetHabit = targetHabit
            self.targetDate = targetDate
            self.alarmTime = alarmTimeString
            self.whiteNoiseType = whiteNoiseType
        } catch {
            print(error)
        }
    }
    
    private func getSelectedDayHabitInfo(selectedDay: Date) {
        do {
            let selectedHabitInfo = try CoreDataManager.shared.getSelectedHabitInfo(selectedDate: currentDate)
            
            guard let goalTime = selectedHabitInfo?.goalTime else { return } // 목표 시간
            
//            self.timerDuration = TimeInterval(goalTime * 60)
            
            /// test용 주석
            self.timerDuration = TimeInterval(goalTime)
        } catch {
            print(error)
        }
    }
    
    private func getUserDataPublisher() -> AnyPublisher<UserData, Never> {
        return Just(UserData(targetHabit: targetHabit, targetDate: targetDate, alarmTime: alarmTime, whiteNoiseType: whiteNoiseType))
            .eraseToAnyPublisher()
    }
    
    // 타이머 완료시 실행되는 메서드
    func recordCompletedHabit() {
        CoreDataManager.shared.completedTodyHabit(completedDate: currentDate, note: "")
        timerStatePublisher.send(.done)
    }
}
