//
//  TimerViewModel.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/27.
//

import Combine
import Foundation

// MARK: - TimerViewModel

final class TimerViewModel: InputOutputProtocol {
    struct Input {
        let viewDidLoadSubject: PassthroughSubject<Void, Never>
        let memoButtonTapped: PassthroughSubject<Void, Never>
        let whiteNoiseButtonTapped: PassthroughSubject<Void, Never>
        let timerButtonTapped: PassthroughSubject<Void, Never>
        let submitButtonTapped: PassthroughSubject<Void, Never>
        let whiteNoiseSelected: PassthroughSubject<String, Never>
    }
    
    struct Output {
        let memoButtonAction: AnyPublisher<Void, Never>
        let whiteNoiseButtonAction: AnyPublisher<Void, Never>
        let timerButtonAction: AnyPublisher<Void, Never>
        let submitButtonAction: AnyPublisher<Void, Never>
        let timerStateDidChange: AnyPublisher<TimerState, Never>
        let remainingTime: AnyPublisher<TimeInterval, Never>
        let userData: AnyPublisher<UserData, Never>
    }
    
    private var timer: AnyCancellable?
    private let coreDataManager: CoreDataManagerProtocol
    private let userDefaultsManager: UserDefaultsManagerProtocol
    
    private let timerStatePublisher = CurrentValueSubject<TimerState, Never>(.stopped)
    private lazy var remainingTimePublisher = CurrentValueSubject<TimeInterval, Never>(self.timerDuration)
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Properties
    
    private (set) var timerDuration = TimeInterval()
    private var targetHabit = String()
    private var targetDate = String()
    private var alarmTime = String()
    private var whiteNoiseType = String()
    private let currentDate = Date()
    
    // MARK: - Life Cycle
    
    init(coreDataManager: CoreDataManagerProtocol, userDefaultsManager: UserDefaultsManagerProtocol) {
        self.coreDataManager = coreDataManager
        self.userDefaultsManager = userDefaultsManager
        
        getUserData()
        getSelectedDayHabitInfo(selectedDay: currentDate)
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        input.viewDidLoadSubject
            .sink { [weak self] _ in
                self?.loadTimerState()
            }
            .store(in: &cancellables)
        
        input.whiteNoiseSelected
            .sink { [weak self] selectedWhiteNoise in
                print("Selected White Noise: \(selectedWhiteNoise)")
                self?.whiteNoiseType = selectedWhiteNoise
            }
            .store(in: &cancellables)
        
        let memoAction = input.memoButtonTapped
            .map { print("memoButtonTapped") }
            .eraseToAnyPublisher()
        
        let whiteNoiseButtonAction = input.whiteNoiseButtonTapped
            .print()
            .map { print("WhiteNoiseButtonTapped") }
            .eraseToAnyPublisher()
        
        let timerButtonAction = input.timerButtonTapped
            .map {
                self.handleTimerButtonTapped()
            }
            .eraseToAnyPublisher()
        
        let submitButtonAction = input.submitButtonTapped
            .print()
            .map { [weak self] _ -> Void in
                self?.coreDataManager.updateWhiteNoiseType(with: self?.whiteNoiseType ?? "")
            }
            .eraseToAnyPublisher()
        
        let timerStateDidChange = timerStatePublisher.eraseToAnyPublisher()
        let remainingTime = remainingTimePublisher.eraseToAnyPublisher()
        let userDataPublisher = getUserDataPublisher()
        
        return Output(memoButtonAction: memoAction,
                      whiteNoiseButtonAction: whiteNoiseButtonAction,
                      timerButtonAction: timerButtonAction,
                      submitButtonAction: submitButtonAction,
                      timerStateDidChange: timerStateDidChange,
                      remainingTime: remainingTime,
                      userData: userDataPublisher)
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

// MARK: - UserDefaults

extension TimerViewModel {
    private func updateState(_ newState: TimerState) {
        timerStatePublisher.send(newState)
    }
    
    private func loadTimerState() {
        let timerState = userDefaultsManager.loadTimerState()
        updateState(timerState)
    }
}

// MARK: - CoreData

extension TimerViewModel {
    private func getUserData() {
        do {
            let userData = try coreDataManager.fetchUser()
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
            let selectedHabitInfo = try coreDataManager.getSelectedHabitInfo(selectedDate: currentDate)
            
            guard let goalTime = selectedHabitInfo?.goalTime else { return } // 목표 시간
            
            //            self.timerDuration = TimeInterval((goalTime - 1) * 60)
            
            /// test용 주석
            self.timerDuration = TimeInterval(goalTime - 1)
        } catch {
            print(error)
        }
    }
    
    private func getUserDataPublisher() -> AnyPublisher<UserData, Never> {
        return Just(UserData(targetHabit: targetHabit,
                             targetDate: targetDate,
                             alarmTime: alarmTime,
                             whiteNoiseType: whiteNoiseType))
        .eraseToAnyPublisher()
    }
    
    // 타이머 완료시 실행되는 메서드
    private func recordCompletedHabit() {
        let savedText = UserDefaults.standard.string(forKey: "noteText")
        coreDataManager.completedTodyHabit(completedDate: currentDate, note: savedText ?? "")
        userDefaultsManager.saveTimerState(timerStatePublisher.value)
        timerStatePublisher.send(.done)
    }
}
