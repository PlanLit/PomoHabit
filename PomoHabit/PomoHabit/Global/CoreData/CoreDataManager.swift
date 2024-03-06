//
//  CoreDataManager.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/03/06.
//

import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
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
    func saveContext () {
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
    
    func fetchObject<T: NSManagedObject>(for type: T.Type) -> T? {
        guard let request = T.fetchRequest() as? NSFetchRequest<T> else { fatalError("Could not cast fetchRequest to NSFetchRequest<T>") }
        
        do {
            let objects = try persistentContainer.viewContext.fetch(request)
            return objects.first
        } catch {
            print("Failed to fetch\(T.self): \(error)")
            return nil
        }
    }
    
    func fetchUser() -> User? {
        let request: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let users = try persistentContainer.viewContext.fetch(request)
            return users.first
        } catch {
            print("Failed to fetch User: \(error)")
            return nil
        }
    }
}

// MARK: - Onboarding

extension CoreDataManager {
    func createUser(targetHabit: String, targetDate: Date, targetTime: Date, habitID: UUID) {
        let context = persistentContainer.viewContext
        let user = User(context: context)
        user.targetHabit = targetHabit
        user.targetDate = targetDate
        user.targetTime = targetTime
        // habitID는 언제 만들어주는지?
        user.habitID = habitID
        
        saveContext()
    }
}

// MARK: - Timer

extension CoreDataManager {
    
    /// 홈화면
    func fetchReportInfo() -> (habitName: String, hasDone: Bool, goalTime: Date, whiteNoiseType: String)? {
        if let dailyHabitInfo: DailyHabitInfo = fetchObject(for: DailyHabitInfo.self),
           let user: User = fetchObject(for: User.self),
           let habitName = user.targetHabit,
           let whiteNoiseType = user.whiteNoiseType,
           let goalTime = dailyHabitInfo.targetTime {
            return (habitName: habitName, hasDone: dailyHabitInfo.hasDone, goalTime: goalTime, whiteNoiseType: whiteNoiseType)
        } else {
            print("Failed to fetch DailyHabitInfo or User")
            return nil
        }
    }
    
    /// 완료버튼
    func updateDailyHabitInfo() {
        
    }
    
    /// 화이트노이즈 변경
    func updateWhiteNoise(user: User, with whiteNoiseType: String) {
        user.whiteNoiseType = whiteNoiseType
    }
    
    /// 등록하기 따로 만들지?
    
}

// MARK: - Reports

extension CoreDataManager {
    
    /// 이번달 레포트
    func fetchReportInfo() -> (habitName: String, hasDone: Bool)? {
        if let dailyHabitInfo: DailyHabitInfo = fetchObject(for: DailyHabitInfo.self),
           let user: User = fetchObject(for: User.self),
           let habitName = dailyHabitInfo.habitName,
           let targetTime = dailyHabitInfo.targetTime {
            return (habitName: habitName, hasDone: dailyHabitInfo.hasDone)
        } else {
            print("Failed to fetch DailyHabitInfo")
            return nil
        }
    }
    
    /// 습관 정보 모달
    func fetchHabitInfo() -> (goalTime: Date, note: String)? {
            if let info: DailyHabitInfo = fetchObject(for: DailyHabitInfo.self),
               let goalTime = info.goalTime,
               let note = info.note {
                return (goalTime: goalTime, note: note)
            } else {
                print("Failed to fetch DailyHabitInfo")
                return nil
            }
        }
    
    /// 메모텍스트 변경
    func updateMemoText() {
        
    }
    
    /// 습관 변경
    func updateHabitTargets(user: User, habitID: UUID, targetDate: Date, targetTime: Date) {
        user.habitID = habitID
        user.targetDate = targetDate
        user.targetTime = targetTime
        
        saveContext()
    }
}

// MARK: - Calendar

extension CoreDataManager {
    func fetchCalendarViewInfo() -> (habitName: String, hasDone: Bool, goalTime: Date, targetTime: Date)? {
        if let info: DailyHabitInfo = fetchObject(for: DailyHabitInfo.self),
           let habitName = info.habitName,
           let goalTime = info.goalTime,
           let targetTime = info.targetTime {
            return (habitName: habitName, hasDone: info.hasDone, goalTime: goalTime, targetTime: targetTime)
        } else {
            print("Failed to fetch DailyHabitInfo")
            return nil
        }
    }
}


// MARK: - Mypage

extension CoreDataManager {
    func fetchMypageViewInfo() -> (ongoingDays: Int, totalProgressedTime: Int)? {
        if let totalHabitInfo: TotalHabitInfo = fetchObject(for: TotalHabitInfo.self) {
            let ongoingDays = Int(totalHabitInfo.onGoingDaysCount)
            let totalProgressedTime = Int(totalHabitInfo.totalProggressedTime)
            return (ongoingDays, totalProgressedTime)
        } else {
            print("Failed to fetch TotalHabitInfo")
            return nil
        }
    }
    
    /// 닉네임 변경
    func updateNickname() {
        
    }
}

