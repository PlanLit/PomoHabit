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
    var startTime: String
    var whiteNoiseType: String
}

// MARK: - TimerModel

final class TimerModel: InputOutputProtocol {
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
    
    private (set) var timerDuration: TimeInterval = 300
    
    private var targetHabit = String()
    private var targetDate = String()
    private var startTime = String()
    private var whiteNoiseType = String()
    
    let currentDate = Date() // 테스트할때 사용하시고 지워주시면 됩니다.
    let date = Date().dateToString(format: "yyyy-MM-dd")

    
    init() {
        getUserData()
        getSelectedDayHabitInfo(selectedDay: date)
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

extension TimerModel {
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

extension TimerModel {
    func getUserData() {
        do {
            let userData = try CoreDataManager.shared.fetchUser()
            guard let targetHabit = userData?.targetHabit,
                  let targetDate = userData?.targetDate,
                  let startTime = userData?.startTime,
                  let whiteNoiseType = userData?.whiteNoiseType else { return }
            
            self.targetHabit = targetHabit
            self.targetDate = targetDate
            self.startTime = startTime
            self.whiteNoiseType = whiteNoiseType
        } catch {
            print(error)
        }
    }
    
    private func getSelectedDayHabitInfo(selectedDay: String) {
        do {
            let habitInfos = try CoreDataManager.shared.fetchDailyHabitInfos()
            let habitInfoDays = habitInfos.compactMap{ $0.day }
            
            if let index = habitInfoDays.firstIndex(where: { $0 == selectedDay }) {
                let selectedHabitInfo = habitInfos[index]
                guard let day = selectedHabitInfo.day else { return }
                let goalTime = selectedHabitInfo.goalTime
                let hasDone = selectedHabitInfo.hasDone
                guard let note = selectedHabitInfo.note else { return }
                
                print("day :\(day),goalTime:\(goalTime),hasDone:\(hasDone),note:\(note)") // 데이터 확인을 위하여 임시로 적어 두었습니다.
            }
        } catch {
            print(error)
        }
    }
    
    private func getUserDataPublisher() -> AnyPublisher<UserData, Never> {
        return Just(UserData(targetHabit: targetHabit, targetDate: targetDate, startTime: startTime, whiteNoiseType: whiteNoiseType))
            .eraseToAnyPublisher()
    }
    
    func completedDailyHabit() { // 타이머 완료시 실행되는 메서드
        
        CoreDataManager.shared.createDailyHabitInfo(day: date, goalTime: 7, hasDone: true, note: "3번째 날입니다.")
    }
}
