//
//  UserDefaultsManager.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/03/26.
//

import Foundation

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    private let timerStateKey = "TimerStateKey"
}

extension UserDefaultsManager {
    func saveTimerState(_ state: TimerState) {
        UserDefaults.standard.set(state.rawValue, forKey: "TimerStateKey")
    }
    
    func loadTimerState() -> TimerState {
        guard let rawValue = UserDefaults.standard.string(forKey: timerStateKey),
              let state = TimerState(rawValue: rawValue) else {
            return .stopped
        }
        return state
    }
}
