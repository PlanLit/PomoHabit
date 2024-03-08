//
//  MypageViewController.swift
//  PomoHabit
//
//  Created by 洪立妍 on 3/5/24.
//

import UIKit

import SnapKit

// MARK: - MyPageViewController

final class MyPageViewController: UIViewController, BottomSheetPresentable {
    
    // MARK: - Properties
    
    private let myPageRootView = MyPageView()
    private let nicknameEditView = NicknameEditView()
    
    // MARK: - View Lifecycle
    
    override func loadView() {
        super.loadView()
        
        view = myPageRootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presentBottomSheet(rootView: nicknameEditView, detents: [.large()])
    }
}

// MARK: - Data 전처리

extension MyPageViewController {
    private func setTotalHabitInfo() {
        do {
            let dailyHabitInfos = try CoreDataManager.shared.fetchDailyHabitInfos() // 전체 DailyHabit 데이터
            let totalHabitDoneCount = dailyHabitInfos.filter{ $0.hasDone == true }.count // 습관 진행 일수
            let totlaHabitDuringTime = dailyHabitInfos.filter{ $0.hasDone == true }.map{$0.goalTime}.reduce(0, +) // 진행 총 시간 , 분단위
            // 완료한 습관 수를 어떻게 할것인지 상의 필요할것 같습니다.
            
        } catch {
            
        }
    }
}
