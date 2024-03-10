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
    }
    
    private let timerStatePublisher = CurrentValueSubject<TimerState, Never>(.stopped)
    private var remainingTimePublisher = CurrentValueSubject<TimeInterval, Never>(0)
    private var cancellables = Set<AnyCancellable>()
    private var timer: AnyCancellable?
    
    private (set) var timerDuration: TimeInterval = 60
    
    
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
        
        return Output(memoButtonAction: memoAction,
                      whiteNoiseButtonAction: whiteNoiseButtonAction,
                      timerButtonAction: timerButtonAction,
                      timerStateDidChange: timerStateDidChange,
                      remainingTime: remainingTime)
    }
}

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
