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
        forEditButtonDelegate()
    }
}

// MARK: - Data 전처리

extension MyPageViewController {
    private func setTotalHabitInfo() {
        //        do {
        //            let dailyHabitInfos = try CoreDataManager.shared.fetchDailyHabitInfos() // 전체 DailyHabit 데이터
        //            let totalHabitDoneCount = dailyHabitInfos.filter{ $0.hasDone == true }.count // 습관 진행 일수
        //            let totlaHabitDuringTime = dailyHabitInfos.filter{ $0.hasDone == true }.map{$0.goalTime}.reduce(0, +) // 진행 총 시간 , 분단위
        //            // 완료한 습관 수를 어떻게 할것인지 상의 필요할것 같습니다.
        //
        //        } catch {
        //
        //        }
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

// MARK: - EditButtonDelegate

extension MyPageViewController: EditButtonDelegate {
    func editButtonTapped() {
        nicknameEditView.isHidden = false
        presentBottomSheet(viewController: NicknameViewController())
    }
    
    func forEditButtonDelegate() {
        myPageRootView.editButtonDelegate = self
    }
}

// MARK: - UITableViewDelegate

extension MyPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectModel = myPageCellModels[indexPath.row]
        
        switch selectModel.title {
        case "오픈 소스 사용":
            if let navigationController = customNavigationController {
                navigationController.pushViewController(openSourceViewController, animated: true)
            }
        case "고객 센터":
            if let navigationController = customNavigationController {
                navigationController.pushViewController(customerServiceViewController, animated: true)
            }
        default:
            break
        }
        navigationController?.isNavigationBarHidden = false
    }
}
