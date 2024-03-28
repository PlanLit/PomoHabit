//
//  TimerState.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/03/28.
//

enum TimerState: String {
    /// 진행 전
    case stopped = "stopped"
    /// 진행 중
    case running = "running"
    /// 타이머 종료
    case finished = "finished"
    /// 완료
    case done = "done"
}
