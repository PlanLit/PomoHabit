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
        
        forEditButtonDelegate()
    }
}

// MARK: - Methods

extension MyPageViewController: EditButtonDelegate {
    func editButtonTapped() {
        let nicknameEditView = NicknameEditView()
        nicknameEditView.isHidden = false
        presentBottomSheet(rootView: nicknameEditView, detents: [.large()])
    }
}

extension MyPageViewController{
    func forEditButtonDelegate() {
        myPageRootView.editButtonDelegate = self
    }
}
// MARK: - Data 전처리

extension MyPageViewController {
    private func setTotalHabitInfo() {
        //        do {
        //            let dailyHabitInfos = try CoreDataManager.shared.fetchDailyHabitInfos()
        //            let totalHabitDoneCount = dailyHabitInfos.filter{ $0.hasDone == true }.count
        //            let totlaHabitDuringTime = dailyHabitInfos.filter{ $0.hasDone == true }.map{$0.goalTime}.reduce(0, +)
        //
        //        } catch {
        //
        //        }
    }
}
