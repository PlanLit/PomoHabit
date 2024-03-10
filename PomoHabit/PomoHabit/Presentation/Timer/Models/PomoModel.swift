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
    }
    
    private let timerStatePublisher = CurrentValueSubject<TimerState, Never>(.stopped)
    private var remainingTimePublisher = CurrentValueSubject<TimeInterval, Never>(25 * 60)
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
        
        return Output(memoButtonAction: memoAction,
                      whiteNoiseButtonAction: whiteNoiseButtonAction,
                      timerButtonAction: timerButtonAction,
                      timerStateDidChange: timerStateDidChange)
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
        
        timer = Timer.publish(every: timerDuration, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.timerStatePublisher.send(.finished)
            }
    }
    
    private func stopTimer() {
        timer?.cancel()
        timerStatePublisher.send(.stopped)
    }
}
