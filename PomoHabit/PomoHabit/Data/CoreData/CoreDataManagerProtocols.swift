//
//  CoreDataManagerProtocols.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/03/31.
//

import Foundation

protocol CoreDataManagerProtocol {
    func fetchUser() throws -> User?
    func updateWhiteNoiseType(with whiteNoiseType: String)
    func completedTodyHabit(completedDate: Date, note: String)
    func getSelectedHabitInfo(selectedDate: Date) throws -> TotalHabitInfo?
}

