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
    
    // MARK: - UI Properties
    
    private let navigationBar = PobitNavigationBarView(title: "습관 달성률", viewType: .plain)
    private lazy var headerView: HStackView = makeHeaderView()
    private lazy var imageCollectionViewController: ReportImageCollectionViewController = makeImageCollectionViewController()
    private lazy var gridView: VStackView = makeGridView()
    private lazy var habitIndicatorView = HabitIndicatorView()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for item in totalHabitInfItems! {
            print()
            print(item.date?.dateToString(format: "MMdd"))
            print(item.hasDone)
        }
        print(Date().dateToString(format: "MMdd"))
        
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
                self.presentBottomSheet(rootView: ReportHabitInfoView(frame: .null,
                                                                      daysButtonSelectionState: self.getMonthData(),
                                                                      startTime: self.user?.alarmTime?.dateToString(format: "hh : mm a")),
                                        detents: [.medium()])
            })
            
            let habitEdit = UIAction(title: "습관 변경", attributes: .destructive, handler: { _ in
                let alertController = UIAlertController(title: "", message: "진행 중인 습관을 초기화하시겠습니까?", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "네", style: .destructive, handler: { action in
                    let nickname = self.user?.nickname
                    
                    CoreDataManager.shared.deleteAllData(entityName: "User")
                    CoreDataManager.shared.deleteAllData(entityName: "TotalHabitInfo")
                    
                    let onboardingHabitRegisterViewController = OnboardingHabitRegisterViewController()
                    onboardingHabitRegisterViewController.setData(nickname)
                    
                    self.navigationController?.setViewControllers([onboardingHabitRegisterViewController], animated: true)
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

    private func makeGridView() -> VStackView {
        func getTheBoxView(_ day: Int,_ width: UInt = 56,_ height: UInt = 45) -> UIButton {
            let boxView = UIButton(type: .system, primaryAction: .init(handler: { _ in
                let reportHabitDetailView = ReportHabitDetailView(frame: .zero, self.totalHabitInfItems?[day])
                reportHabitDetailView.reportViewController = self
                self.presentBottomSheet(rootView: reportHabitDetailView, detents: [.large()])
            }))
            boxView.layer.cornerRadius = 10
            boxView.clipsToBounds = true
            boxView.alpha = totalHabitInfItems![day].date?.dateToString(format: "MMdd") ?? "" < Date().dateToString(format: "MMdd") ? 1 : 0.1
            if totalHabitInfItems![day].date?.dateToString(format: "MMdd") ?? "" >= Date().dateToString(format: "MMdd") {
                boxView.backgroundColor = .pobitRed
            } else if totalHabitInfItems![day].hasDone {
                boxView.backgroundColor = day == 0 ? .pobitGreen : .pobitRed
            } else {
                boxView.backgroundColor = .pobitStone2
            }
            
            boxView.snp.makeConstraints { make in
                make.width.equalTo(width)
                make.height.equalTo(height)
            }
             
            return boxView
        }
        
        let gridView = VStackView(alignment: .center, [
            HStackView([
                getTheBoxView(0, 56*3, 45),
            ]),
            HStackView([
                getTheBoxView(1),
                getTheBoxView(2),
                getTheBoxView(3),
                getTheBoxView(4),
                getTheBoxView(5),
            ]),
            HStackView([
                getTheBoxView(6),
                getTheBoxView(7),
                getTheBoxView(8),
                getTheBoxView(9),
                getTheBoxView(10),
            ]),
            HStackView([
                getTheBoxView(11),
                getTheBoxView(12),
                getTheBoxView(13),
                getTheBoxView(14),
                getTheBoxView(15),
            ]),
            HStackView([
                getTheBoxView(16),
                getTheBoxView(17),
                getTheBoxView(18),
                getTheBoxView(19),
                getTheBoxView(20),
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
