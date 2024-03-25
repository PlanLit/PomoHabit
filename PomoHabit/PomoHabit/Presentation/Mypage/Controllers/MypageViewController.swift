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
    private var customNavigationController: UINavigationController? = nil
    private let openSourceViewController = OpenSourceViewController()
    private let customerServiceViewController = CustomerServiceViewController()
    private let nicknameViewController = NicknameViewController()
    
    // MARK: - View Lifecycle
    
    override func loadView() {
        super.loadView()
        
        view = myPageRootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myPageRootView.getTableView().delegate = self
        setTotalHabitInfo()
        setupCustomNavigationController()
        setDelegateforEditButton()
        setNicknameData()
        setTotalHabitInfo()
        nicknameViewController.onNicknameEdit = { nickname in
            self.myPageRootView.updateNicknameLabel(with: nickname)
        }
    }
}

// MARK: - Data 전처리

extension MyPageViewController {
    private func setNicknameData() {
        do {
            if let user = try CoreDataManager.shared.fetchUser() {
                let userNickname = user.nickname ?? "" //
                myPageRootView.getNicknameLabel().text = userNickname
            } else {
                myPageRootView.getNicknameLabel().text = "없음"
            }
        } catch {
            print("Error")
        }
    }
}

extension MyPageViewController {
    private func setTotalHabitInfo() {
        let (totalTime, totalDays) = CoreDataManager.shared.getTotalTimeAndDays()
        let totalTimeString = "\(totalTime) 분"
        let totalDaysString = "\(totalDays) 일"
        myPageRootView.updateTotalMinutesLabel(totalTimeString)
        myPageRootView.updateTotalDaysLabel(totalDaysString)
    }
}

// MARK: - Method

extension MyPageViewController {
    private func setupCustomNavigationController() {
        customNavigationController = navigationController
    }
    
    func sendDataToNicknamePlaceholder() {
        let nicknameViewController = NicknameViewController()
        let nicknameLabel = myPageRootView.getNicknameLabel()
        
        nicknameViewController.onDataReceived = { [weak self] data in
            nicknameLabel.text = data
            self?.nicknameEditView.setPlaceholderForTextField()
        }
        navigationController?.pushViewController(nicknameViewController, animated: true)
    }
}

// MARK: - Action Helper

extension MyPageViewController {
    func editNickname(with nickname: String) {
        myPageRootView.updateNicknameLabel(with: nickname)
    }
}

// MARK: - EditButtonDelegate

extension MyPageViewController: EditButtonDelegate {
    func editButtonTapped() {
        nicknameEditView.isHidden = false
        presentBottomSheet(viewController: nicknameViewController)
    }
    
    func setDelegateforEditButton() {
        myPageRootView.editButtonDelegate = self
    }
}

// MARK: - UITableViewDelegate

extension MyPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        _ = myPageCellModels[indexPath.row]
        
        switch indexPath.row {
        case 0:
//            navigationController?.pushViewController(openSourceViewController, animated: true)
            presentBottomSheet(viewController: openSourceViewController)
        case 1:
//            navigationController?.pushViewController(customerServiceViewController, animated: true)
            presentBottomSheet(viewController: customerServiceViewController)
            
        default:
            break
        }
        navigationController?.isNavigationBarHidden = false
    }
}
