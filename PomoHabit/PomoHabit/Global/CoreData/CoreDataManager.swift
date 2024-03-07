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
                print("성공적으로 데이터가 저장되었습니다.")
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
    
    private func fetchObjects<T: NSManagedObject>(for type: T.Type) throws -> [T] {
        let entityName = String(describing: T.self)
        let request = NSFetchRequest<T>(entityName: entityName)
        
        let context = persistentContainer.viewContext
        
        var fetchedObject : [T] = []
        var fetchError: Error?
        
        context.performAndWait {
            do {
                let objects = try context.fetch(request)
                fetchedObject = objects
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
                return user
            } else {
                throw CoreDataError.fetchFailed(reason: "Failed to fetch User")
            }
        } catch let error {
            print("Fetching user failed with error: \(error)")
            throw CoreDataError.fetchFailed(reason: error.localizedDescription)
        }
    }
    
    func fetchDailyHabitInfos() throws -> [DailyHabitInfo] {
        do {
            let dailyHabitInfos : [DailyHabitInfo] = try fetchObjects(for: DailyHabitInfo.self)
            return dailyHabitInfos
        } catch let error {
            print("Fetching user failed with error: \(error)")
            throw CoreDataError.fetchFailed(reason: error.localizedDescription)
        }
    }
}

// MARK: - Onboarding

extension CoreDataManager {
    func createUser(nickname: String,targetHabit: String, targetDate: String,startTime: String,whiteNoiseType: String?) {
        
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
        
        user.nickName = nickname // 닉네임
        user.targetHabit = targetHabit // 습관정보
        user.targetDate = targetDate // 습관 진행요일
        user.startTime = startTime // 습관 진행 시간
        user.whiteNoiseType = nil // 사운드
        
        saveContext()
    }
}


// MARK: - Timer

extension CoreDataManager {
    func createDailyHabitInfo(day: String, goalTime: Int16, hasDone: Bool, note: String) {
        let context = persistentContainer.viewContext
        let dailyHabitInfo = DailyHabitInfo(context: context)
        
        dailyHabitInfo.day = day
        dailyHabitInfo.goalTime = goalTime
        dailyHabitInfo.hasDone = hasDone
        dailyHabitInfo.note = note
        
        saveContext()
    }
}

// MARK: - Delete

extension CoreDataManager {
    func deleteAllData(entityName: String) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
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

// MARK: - 파일 저장 경로

extension CoreDataManager {
    func getSaveCoredataPath(){
        if let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            print("Documents Directory: \(documentsDirectoryURL)")
        }
    }
}
