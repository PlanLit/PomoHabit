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
    
    private func fetchObject<T: NSManagedObject>(for type: T.Type) throws -> T? { // User & TotalHabitInfo fetch (User와 TotalHabitInfo은 하나의 객체만 사용)
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
    
    private func fetchObjects<T: NSManagedObject>(for type: T.Type) throws -> [T] { // DailyHabiInfo fetch (DailyHabiInfo는 여러개의 객체 사용)
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
    
    func fetchUser() throws -> User? { // CordData에서 User데이터 Read
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
    
    func fetchTotalHabitInfo() throws -> [TotalHabitInfo] {
        do {
            let dailyHabitInfos: [TotalHabitInfo] = try fetchObjects(for: TotalHabitInfo.self)
            
            return dailyHabitInfos
        } catch let error {
            print("Fetching user failed with error: \(error)")
            throw CoreDataError.fetchFailed(reason: error.localizedDescription)
        }
    }
}

// MARK: - Onboarding

extension CoreDataManager {
    func createUser(nickname: String, targetHabit: String, targetDate: String, alarmTime: Date, whiteNoiseType: String?) { // User 엔티티 저장
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
        
        user.nickname = nickname // 닉네임
        user.targetHabit = targetHabit // 습관정보
        user.targetDate = targetDate // 습관 진행요일
        user.alarmTime = alarmTime // 매일 시작하기로한 시간 - 알람 시간
        user.whiteNoiseType = whiteNoiseType // 사운드
        
        saveContext()
    }
}

// MARK: - MyPage

extension CoreDataManager {
    func updateUsernickName(nickname: String) {
        do {
            let userData = try fetchUser()
            
            userData?.setValue(nickname, forKey: "nickname")
            saveContext()
        } catch {
            print(error)
        }
    }
}


// MARK: - Timer

extension CoreDataManager {
    func createTotalHabitInfo(date: Date, goalTime: Int16, hasDone: Bool, note: String) { // DailyHabitInfo 엔티티 저장
        let context = persistentContainer.viewContext
        let totalHabitInfo = TotalHabitInfo(context: context)
        
        totalHabitInfo.date = date
        totalHabitInfo.goalTime = goalTime
        totalHabitInfo.hasDone = hasDone
        totalHabitInfo.note = note
        
        saveContext()
    }
}
// MARK: - MockData

extension CoreDataManager {
    func setMockupTotalHabitInfo(targetDate: String) { // 목업 데이터 생성
        let targetDayInfos = targetDate.split(separator: ",").map{String($0)}
        let calendar = Calendar.current
        var appendCount = 0
        var goalTime = 5
        var date = Date()
        
        if targetDayInfos.contains(date.getDayOfWeek()){ // 오늘 습관을 진행하는 날짜인지 확인후 목데이터에 추가
            createTotalHabitInfo(date: date, goalTime: Int16(goalTime), hasDone: false, note: "")
        }
        
        while appendCount != 20 {
            date = calendar.date(byAdding: .day,value: 1, to: date) ?? Date()
            
            if targetDayInfos.contains(date.getDayOfWeek()) { // 습관 진행하는 요일이면 추가
                goalTime += 1
                createTotalHabitInfo(date: date, goalTime: Int16(goalTime), hasDone: false, note: "")
                appendCount += 1
            }
        }
    }
}

// MARK: - Timer 습관 완료후 오늘 날짜의 TotalHabitInfo MockData 수정

extension CoreDataManager {
    func completedTodyHabit(completedDate: Date, note: String) {
        do {
            let totalHabitInfo = try fetchTotalHabitInfo()
            for (idx,habitInfo) in totalHabitInfo.enumerated() {
                guard let habitInfoDate = habitInfo.date else { return }
                if habitInfoDate.comparisonDate(fromDate: completedDate) == 0 {
                    totalHabitInfo[idx].setValue(completedDate, forKey: "date")
                    totalHabitInfo[idx].setValue(true, forKey: "hasDone")
                    totalHabitInfo[idx].setValue(note, forKey: "note")
                }
                
                saveContext()
            }
        } catch {
            print(error)
        }
    }
}

// MARK: - TotalHabitInfo 특정 날짜 정보 얻기

extension CoreDataManager {
    func getSelectedHabitInfo(selectedDate: Date) throws -> TotalHabitInfo? {
        do {
            let totalHabitInfo = try fetchTotalHabitInfo()
            for (idx,habitInfo) in totalHabitInfo.enumerated() {
                let habitInfoDate = habitInfo.date ?? Date()
                if habitInfoDate.comparisonDate(fromDate: selectedDate) == 0 {
                    
                    return totalHabitInfo[idx]
                }
            }
        } catch {
            print(error)
            print("Fetching user failed with error: \(error)")
            throw CoreDataError.fetchFailed(reason: error.localizedDescription)
        }
        
        return nil
    }
}

// MARK: - 해당 엔티티 All Delete

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

// MARK: - CoreData 파일 저장 경로 얻는 함수

extension CoreDataManager {
    func getSaveCoredataPath(){
        if let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            print("Documents Directory: \(documentsDirectoryURL)")
        }
    }
}

// MARK: - CoreData 총 일수, 총 시간

extension CoreDataManager {
    func getTotalTimeAndDays() -> (totalTime: Int, total: Int) {
        do {
            let totalHabitInfos = try CoreDataManager.shared.fetchTotalHabitInfo()
            var totalHabitDoneCount = 0
            var totalHabitDuringTime = 0
            for habitInfo in totalHabitInfos {
                if habitInfo.hasDone {
                    totalHabitDoneCount += 1
                    totalHabitDuringTime += Int(habitInfo.goalTime)
                }
            }
            
            return (totalHabitDuringTime, totalHabitDoneCount)
            
        } catch {
            print(error)
            return (0, 0)
        }
    }
}
