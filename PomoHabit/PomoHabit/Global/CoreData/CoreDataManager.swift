//
//  CoreDataManager.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/03/06.
//

import CoreData

enum CoreDataError: Error {
    case fetchFailed(reason: String)
}

// MARK: - CoreDataManager

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PobitModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() {}
}

// MARK: - Global

extension CoreDataManager {
    private func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private func fetchObject<T: NSManagedObject>(for type: T.Type) throws -> T? {
        let entityName = String(describing: T.self)
        let request = NSFetchRequest<T>(entityName: entityName)
        
        let context = persistentContainer.viewContext
        
        var fetchedObject: T?
        var fetchError: Error?
        
        context.performAndWait {
            do {
                let objects = try context.fetch(request)
                fetchedObject = objects.first
            } catch {
                fetchError = error
            }
        }
        
        if let error = fetchError {
            throw error
        }
        
        return fetchedObject
    }
    
    
    func fetchUser() throws -> User? {
        do {
            if let user: User = try fetchObject(for: User.self) {
                print(user)
                return user
            } else {
                throw CoreDataError.fetchFailed(reason: "Failed to fetch User")
            }
        } catch let error {
            print("Fetching user failed with error: \(error)")
            throw CoreDataError.fetchFailed(reason: error.localizedDescription)
        }
    }
    
    private func updateGoalTime(for habitInfo: DailyHabitInfo) {
        let currentGoalTimeInSeconds = habitInfo.goalTime?.timeIntervalSinceReferenceDate ?? 5 * 60
        let updatedGoalTimeInSeconds = min(currentGoalTimeInSeconds + 60, 25 * 60)
        habitInfo.goalTime = Date(timeIntervalSinceReferenceDate: updatedGoalTimeInSeconds)
    }
}

// MARK: - Onboarding

extension CoreDataManager {
    func createUser(nickname: String, targetHabit: String, targetDate: Date, targetTime: Date) {
        
        // db에 이미 존재하는 유저가 있는지 확인
        do {
            if let _ = try fetchUser() {
                print("유저가 이미 존재합니다")
                return
            }
        } catch {
            print(error)
        }
        
        let context = persistentContainer.viewContext
        let user = User(context: context)
        user.nickname = nickname
        user.targetHabit = targetHabit
        user.targetDate = targetDate
        user.targetTime = targetTime
        user.whiteNoiseType = nil
        
        saveContext()
        
        // 테스트용
        if let savedNickname = user.nickname {
            print("Saved nickname: \(savedNickname)")
        }
    }
    
    // 습관 생성, 변경
    func createDailyHabitInfo(user: User, targetTime: Date, hasDone: Bool, note: String) {
        let context = persistentContainer.viewContext
        let dailyHabitInfo = DailyHabitInfo(context: context)
        let initialGoalTime = 5 * 60
        
        dailyHabitInfo.targetTime = targetTime
        dailyHabitInfo.hasDone = hasDone
        dailyHabitInfo.note = note
        dailyHabitInfo.goalTime = Date(timeIntervalSinceReferenceDate: TimeInterval(initialGoalTime))
        
        saveContext()
    }
}

// MARK: - Timer

extension CoreDataManager {
    func fetchReportInfo() throws -> (habitName: String, hasDone: Bool, goalTime: Date, whiteNoiseType: String)? {
        guard let dailyHabitInfo: DailyHabitInfo = try fetchObject(for: DailyHabitInfo.self),
              let user: User = try fetchObject(for: User.self),
              let habitName = user.targetHabit,
              let whiteNoiseType = user.whiteNoiseType,
              let goalTime = dailyHabitInfo.targetTime else {
            throw CoreDataError.fetchFailed(reason: "Failed to fetch User in \(#function)")
        }
        return (habitName: habitName, hasDone: dailyHabitInfo.hasDone, goalTime: goalTime, whiteNoiseType: whiteNoiseType)
    }
    
    /// 완료버튼
    func updateDailyHabitInfo(with hasDone: Bool, note: String) throws {
        if let dailyHabitInfo: DailyHabitInfo = try fetchObject(for: DailyHabitInfo.self) {
            dailyHabitInfo.hasDone = hasDone
            dailyHabitInfo.note = note
            if hasDone {
                updateGoalTime(for: dailyHabitInfo)
            }
        }
        
        saveContext()
    }
    
    /// 화이트노이즈 변경
    func updateWhiteNoise(with whiteNoiseType: String) throws {
        if let user: User = try fetchObject(for: User.self) {
            user.whiteNoiseType = whiteNoiseType
        }
        
        saveContext()
    }
}

// MARK: - Reports

extension CoreDataManager {
    
    /// 이번달 레포트
    func fetchCurrentMonthReportInfo() throws -> (habitName: String, hasDone: Bool, targetTime: Date, goalTime: Date)? {
        guard let dailyHabitInfo: DailyHabitInfo = try fetchObject(for: DailyHabitInfo.self),
              let habitName = dailyHabitInfo.habitName,
              let targetTime = dailyHabitInfo.targetTime,
              let goalTime = dailyHabitInfo.goalTime else {
            throw CoreDataError.fetchFailed(reason: "Failed to fetch User in \(#function)")
        }
        
        return (habitName: habitName, hasDone: dailyHabitInfo.hasDone, targetTime: targetTime, goalTime: goalTime)
    }
    
    /// 습관 정보 모달
    func fetchHabitInfo() throws -> (goalTime: Date, note: String)? {
        guard let dailyHabitInfo: DailyHabitInfo = try fetchObject(for: DailyHabitInfo.self),
              let goalTime = dailyHabitInfo.goalTime,
              let note = dailyHabitInfo.note else {
            throw CoreDataError.fetchFailed(reason: "Failed to fetch User in \(#function)")
        }
        return (goalTime: goalTime, note: note)
    }
    
    /// 메모텍스트 변경
    func updateMemoText(with newText: String) throws {
        guard let dailyHabitInfo: DailyHabitInfo = try fetchObject(for: DailyHabitInfo.self) else {
            throw CoreDataError.fetchFailed(reason: "Failed to fetch DailyHabitInfo in \(#function)")
        }
        
        dailyHabitInfo.note = newText
        saveContext()
    }
    
    /// 습관 변경
    func updateHabitTargets(habitID: UUID, targetDate: Date, targetTime: Date) throws {
        guard let user: User = try fetchObject(for: User.self) else {
            throw CoreDataError.fetchFailed(reason: "Failed to fetch User in \(#function)")
        }
        
        user.targetDate = targetDate
        user.targetTime = targetTime
        saveContext()
    }
}

// MARK: - Calendar

extension CoreDataManager {
    func fetchCalendarViewInfo() throws -> (habitName: String, hasDone: Bool, goalTime: Date, targetTime: Date)? {
        guard let dailyHabitInfo: DailyHabitInfo = try fetchObject(for: DailyHabitInfo.self),
              let habitName = dailyHabitInfo.habitName,
              let goalTime = dailyHabitInfo.goalTime,
              let targetTime = dailyHabitInfo.targetTime else {
            throw CoreDataError.fetchFailed(reason: "Failed to fetch DailyHabitInfo in \(#function)")
        }
        
        return (habitName: habitName, hasDone: dailyHabitInfo.hasDone, goalTime: goalTime, targetTime: targetTime)
    }
}

// MARK: - Mypage

extension CoreDataManager {
    func fetchMypageViewInfo() throws -> (ongoingDays: Int, totalProgressedTime: Int)? {
        guard let totalHabitInfo: TotalHabitInfo = try fetchObject(for: TotalHabitInfo.self) else {
            throw CoreDataError.fetchFailed(reason: "Failed to fetch TotalHabitInfo in \(#function)")
        }
        
        let ongoingDays = Int(totalHabitInfo.onGoingDaysCount)
        let totalProgressedTime = Int(totalHabitInfo.totalProggressedTime)
        return (ongoingDays, totalProgressedTime)
    }
    
    /// 닉네임 변경
    func updateUserNickname(to newNickname: String) {
        guard let user = try? fetchObject(for: User.self) else { return }
        user.nickname = newNickname
        saveContext()
        
        // 테스트용
        if let updatedNickname = user.nickname {
            print("Updated nickname: \(updatedNickname)")
        }
    }
}

// MARK: - Delete

extension CoreDataManager {
    func deleteAllData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "User")
        let context = persistentContainer.viewContext
        
        do {
            let objects = try context.fetch(fetchRequest)
            for object in objects {
                if let managedObject = object as? NSManagedObject {
                    context.delete(managedObject)
                }
            }
            try context.save()
        } catch let error {
            print("Error deleting all data: \(error.localizedDescription)")
        }
    }
}
