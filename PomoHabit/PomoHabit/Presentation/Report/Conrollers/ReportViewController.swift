//
//  ReportViewController.swift
//  PomoHabit
//
//  Created by JiHoon K on 2/27/24.
//

import UIKit

// MARK: - ReportViewController

final class ReportViewController: BaseViewController, BottomSheetPresentable {
    
    // MARK: - Data Properties
    
    private lazy var user: User? = getUserData()
    private lazy var totalHabitInfItems: [TotalHabitInfo]? = try? CoreDataManager.shared.fetchTotalHabitInfo()
    private let todayDate = { // 오늘 날짜 정수
        let currentDate = Date()
        let calendar = Calendar.current
        
        return calendar.component(.day, from: currentDate)
    }()
    
    // MARK: - UI Properties
    
    private let navigationBar = PobitNavigationBarView(title: "습관 달성률", viewType: .plain)
    private lazy var headerView: HStackView = makeHeaderView()
    private lazy var imageCollectionViewController: ReportImageCollectionViewController = makeImageCollectionViewController()
    private lazy var gridView: VStackView = makeGridView(31) // 월마다 바뀌는 일 수 주입
    private lazy var habitIndicatorView = HabitIndicatorView()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAddSubviews()
        setAutoLayout()
    }
}

// MARK: - Layout Helpers

extension ReportViewController {
    private func setAddSubviews() {
        addChild(imageCollectionViewController)
        
        view.addSubViews([
            navigationBar,
            headerView,
            imageCollectionViewController.view,
            gridView,
            habitIndicatorView,
        ])
    }
    
    private func setAutoLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(58)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(LayoutLiterals.minimumVerticalSpacing)
            make.left.equalTo(LayoutLiterals.minimumHorizontalSpacing)
            make.right.equalTo(-LayoutLiterals.minimumHorizontalSpacing)
            make.height.equalTo(55)
        }
        
        imageCollectionViewController.view.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(LayoutLiterals.minimumVerticalSpacing)
            make.left.right.equalToSuperview()
            make.height.equalTo(74)
        }
        
        gridView.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionViewController.view.snp.bottom).offset(LayoutLiterals.minimumVerticalSpacing)
            make.centerX.equalToSuperview()
            make.height.equalTo(45*5+(10*4))
        }
        
        habitIndicatorView.snp.makeConstraints { make in
            make.top.equalTo(gridView.snp.bottom).offset(LayoutLiterals.minimumVerticalSpacing)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-LayoutLiterals.minimumVerticalSpacing)
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
        }
    }
}

// MARK: - Factory Methods

extension ReportViewController {
    private func makeHeaderView() -> HStackView {
        let titleLabel = {
            let label = UILabel()
            label.text = "독서"
            label.font = Pretendard.bold(size: 30)
            label.textAlignment = .center
            
            return label
        }()
        
        let rightMenuButton = {
            let button = UIButton(type: .system)
            button.tintColor = .black
            button.setImage(.verticalMenu, for: .normal)
            
            let habitInfo = UIAction(title: "습관 정보", handler: { _ in
                self.presentBottomSheet(viewController: UIViewController())
//                self.presentBottomSheet(rootView: ReportHabitInfoView(frame: .null,
//                                                                      daysButtonSelectionState: self.getMonthData(),
//                                                                      startTime: self.user?.alarmTime?.timeToString()),
//                                        detents: [.medium()])
            })
            
            let habitEdit = UIAction(title: "습관 변경", attributes: .destructive, handler: { _ in
                let alertController = UIAlertController(title: "", message: "진행 중인 습관을 초기화하시겠습니까?", preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: "네", style: .destructive, handler: { action in
                    
                }))
                alertController.addAction(UIAlertAction(title: "아니요", style: .cancel, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            })
            
            let menus = UIMenu(children: [habitInfo, habitEdit])
            
            button.menu = menus
            button.showsMenuAsPrimaryAction = true
            
            return button
        }()
        
        let blankView = {
            let blankView = UIButton(type: .system)
            blankView.setImage(.verticalMenu, for: .normal)
            blankView.alpha = 0
            
            return blankView
        }()
        
        return HStackView([
            blankView,
            titleLabel,
            rightMenuButton
        ])
    }
    
    private func makeImageCollectionViewController() -> ReportImageCollectionViewController {
        let imageCollectionViewController = ReportImageCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        imageCollectionViewController.didMove(toParent: self)
        
        return imageCollectionViewController
    }

    private func makeGridView(_ days: Int) -> VStackView {
        func getTheBoxView(_ day: Int,_ state: Check,_ width: UInt = 56,_ height: UInt = 45) -> UIButton {
            let boxView = {
                let boxView = UIButton(type: .system, primaryAction: .init(handler: { _ in
                    let reportHabitDetailView = ReportHabitDetailView(frame: .zero, self.totalHabitInfItems?[day])
                    reportHabitDetailView.reportViewController = self
//                    self.presentBottomSheet(rootView: reportHabitDetailView, detents: [.large()])
                    self.presentBottomSheet(viewController: UIViewController())
                }))
                boxView.backgroundColor = .pobitRed
                boxView.layer.cornerRadius = 10
                boxView.alpha = day <= todayDate ? 1 : 0.1
                boxView.clipsToBounds = true
                boxView.snp.makeConstraints { make in
                    make.width.equalTo(width)
                    make.height.equalTo(height)
                }
                
                return boxView
            }()
            
            switch state {
            case .complete, .rest:
                boxView.backgroundColor = day <= 1 ? .pobitGreen : .pobitRed
            case .fail:
                boxView.backgroundColor = .pobitStone2
            }
             
            return boxView
        }
        
        let gridView = VStackView(alignment: .center, [
            HStackView([
                getTheBoxView(0, .complete, 56*3, 45),
            ]),
            HStackView([
                getTheBoxView(1, .complete),
                getTheBoxView(2, .complete),
                getTheBoxView(3, .fail),
                getTheBoxView(4, .fail),
                getTheBoxView(5, .complete),
            ]),
            HStackView([
                getTheBoxView(6, .complete),
                getTheBoxView(7, .complete),
                getTheBoxView(8, .complete),
                getTheBoxView(9, .complete),
                getTheBoxView(10, .complete),
            ]),
            HStackView([
                getTheBoxView(11, .complete),
                getTheBoxView(12, .complete),
                getTheBoxView(13, .complete),
                getTheBoxView(14, .complete),
                getTheBoxView(15, .complete),
            ]),
            HStackView([
                getTheBoxView(16, .rest),
                getTheBoxView(17, .rest),
                getTheBoxView(18, .rest),
                getTheBoxView(19, .complete),
                getTheBoxView(20, .complete),
            ]),
        ])
        
        return gridView
    }
    
    private func makeMessageBoxView(_ message: String) -> UILabel {
        let messageBoxView = UILabel()
        messageBoxView.font = Pretendard.regular(size: 16)
        messageBoxView.text = message
        messageBoxView.backgroundColor = UIColor(hex: "#FFDADA")
        messageBoxView.textAlignment = .center
        
        return messageBoxView
    }
}

// MARK: - Data Helpers

extension ReportViewController {
    private func getMonthHabitCompletedInfo() {
        do {
//            try CoreDataManager.shared.habit
//            print("CoreDataManager.shared.fetchDailyHabitInfos: ", try CoreDataManager.shared.fetchDailyHabitInfos())
//            let monthHabitCompletedInfo = try CoreDataManager.shared.fetchDailyHabitInfos().map{$0.hasDone} // 한달 동안의 습관 완료 기록, 습관을 시작하는날이 아닌경우에는 표시안됨
        } catch {
            print(error)
        }
    }
    
    private func getSelectedDayHabitInfo(selectedDay: String) { // selectedDay 매개변수를 통해 해당하는 날짜의 습관정보를 불러옴, 날짜 형식 2024-03-08
        do {
//            let habitInfoDays = habitInfos.compactMap{$0.day}
//            if let index = habitInfoDays.firstIndex(where: {$0 == selectedDay}) {
//                let selectedHabitInfo = habitInfos[index]
//                guard let day = selectedHabitInfo.day else { return }
//                let goalTime = selectedHabitInfo.goalTime
//                let hasDone = selectedHabitInfo.hasDone
//                guard let note = selectedHabitInfo.note else { return }
//            }
        } catch {
            print(error)
        }
    }
    
    private func getUserData() -> User? {
        do {
            let userData = try CoreDataManager.shared.fetchUser()
            return userData
        } catch {
            print(error)
        }
        
        return nil
    }
    
    // CoreData의 데이터를 뷰에 뿌려주기 위한 데이터로 변환해서 반환
    private func getMonthData() -> [Bool] {
        var days = [false, false, false, false, false, false, false]
        for day in user?.targetDate ?? "" {
            switch day {
            case "월":
                days[0] = true
            case "화":
                days[1] = true
            case "수":
                days[2] = true
            case "목":
                days[3] = true
            case "금":
                days[4] = true
            case "토":
                days[5] = true
            case "일":
                days[6] = true
            default: break
            }
        }
        
        return days
    }
}

// MARK: - Types

extension ReportViewController {
    enum Check {
        case complete, fail, rest
    }
}
