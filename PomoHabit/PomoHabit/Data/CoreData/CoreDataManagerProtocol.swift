//
//  CoreDataManagerProtocol.swift
//  PomoHabit
//
//  Created by 원동진 on 5/30/24.
//

import Foundation
protocol CoreDataManagerProtocol {
    func fetchUser() throws -> User?
    func updateWhiteNoiseType(with whiteNoiseType: String)
    func completedTodyHabit(completedDate: Date, note: String)
    func getSelectedHabitInfo(selectedDate: Date) throws -> TotalHabitInfo?
}
