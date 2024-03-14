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
        
        setTotalHabitInfo()
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
            let dailyHabitInfos = try CoreDataManager.shared.fetchDailyHabitInfos()
            let totalHabitDoneCount = dailyHabitInfos.filter{ $0.hasDone == true }.count
            myPageRootView.updateTotalDaysLabel("\(totalHabitDoneCount) 일")
            let totalHabitDuringTime = dailyHabitInfos.filter{ $0.hasDone == true }.map{$0.goalTime}.reduce(0, +)
            myPageRootView.updateTotalMinutesLabel("\(totalHabitDuringTime) 분")
        } catch {
            print(error)
        }
    }
}
