//
//  TimerModel.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/27.
//

import Combine

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
    }
}

extension TimerModel {
    func transform(input: Input) -> Output {
        let memoAction = input.memoButtonTapped
            .map { print("Memo button tapped") }
            .eraseToAnyPublisher()
        
        let whiteNoiseButtonAction = input.whiteNoiseButtonTapped
            .map { print("White Noise button tapped") }
            .eraseToAnyPublisher()
        
        let timerButtonAction = input.timerButtonTapped
            .map { print("Timer button tapped") }
            .eraseToAnyPublisher()
        
        return Output(memoButtonAction: memoAction,
                      whiteNoiseButtonAction: whiteNoiseButtonAction,
                      timerButtonAction: timerButtonAction)
    }
}
