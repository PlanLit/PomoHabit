//
//  ViewController.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/26.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
extension ViewController { // CoreData 활용 예시, 뷰 바인딩 끝난후 삭제 필요
    private func createMockupTotalHabitInfo() { // 목데이터 생성
        do{
            let userInfo = try CoreDataManager.shared.fetchUser()
            guard let dayInfos = userInfo?.targetDate else { return }
            CoreDataManager.shared.setMockupTotalHabitInfo(today: Date(), targetDate: dayInfos)
        } catch {
            print(error)
        }
    }
    
    private func getSelectedHabitInfo(selectedDate : Date) { // 날짜를 통해 습관정보 찾는함수
        do {
            let selectedHabitData = try CoreDataManager.shared.getSelectedHabitInfo(selectedDate: selectedDate)
            
        } catch {
            print(error)
        }
    }
}
