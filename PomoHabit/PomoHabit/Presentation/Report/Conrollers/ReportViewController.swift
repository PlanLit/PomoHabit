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
    
    private lazy var user: User? = try? CoreDataManager.shared.fetchUser()
    private lazy var totalHabitInfItems: [TotalHabitInfo]? = try? CoreDataManager.shared.fetchTotalHabitInfo()
    
    // MARK: - UI Properties
    
    private let navigationBar = PobitNavigationBarView(title: "습관 달성률", viewType: .plain)
    private lazy var headerView: HStackView = makeHeaderView()
    private lazy var imageCollectionViewController: ReportImageCollectionViewController = makeImageCollectionViewController()
    private lazy var habitAchievementLabelView: UILabel = makeHabitAchievementLabelView()
    private lazy var gridView: VStackView = makeGridView()
    private lazy var habitIndicatorView = HabitIndicatorView()
    private lazy var messageBoxView: UILabel = makeMessageBoxView("모두 완료하면 토마토가 웃는얼굴이 돼요")
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAddSubviews()
        setAutoLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
        
        DispatchQueue.main.async {
            self.updateUI()
        }
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
            habitAchievementLabelView,
            gridView,
            habitIndicatorView,
            messageBoxView
        ])
    }
    
    private func setAutoLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
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
            make.height.equalTo(100)
        }
        
        habitAchievementLabelView.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionViewController.view.snp.bottom).offset(LayoutLiterals.minimumVerticalSpacing)
            make.centerX.equalToSuperview()
        }
        
        gridView.snp.makeConstraints { make in
            make.top.equalTo(habitAchievementLabelView.snp.bottom).offset(LayoutLiterals.minimumVerticalSpacing)
            make.centerX.equalToSuperview()
            make.height.equalTo(45 * 5 + (10 * 4))
        }
        
        habitIndicatorView.snp.makeConstraints { make in
            make.top.equalTo(gridView.snp.bottom).offset(LayoutLiterals.minimumVerticalSpacing)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-LayoutLiterals.minimumVerticalSpacing)
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
        }
        
        messageBoxView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
    }
    
    private func updateUI() {
        imageCollectionViewController.setData(getHabitAchievementRate())
        imageCollectionViewController.collectionView.reloadData()
        
        habitAchievementLabelView.text = "\(getHabitAchievementRate())%"
        
        let newGridView = makeGridView()
        gridView.removeFromSuperview()
        gridView = newGridView
        view.addSubview(gridView)
        gridView.snp.makeConstraints { make in
            make.top.equalTo(habitAchievementLabelView.snp.bottom).offset(LayoutLiterals.minimumVerticalSpacing)
            make.centerX.equalToSuperview()
            make.height.equalTo(45 * 5 + (10 * 4))
        }
    }
}

// MARK: - Factory Methods

extension ReportViewController {
    private func makeHeaderView() -> HStackView {
        let titleLabel = {
            let label = UILabel()
            label.text = user?.targetHabit
            label.font = Pretendard.bold(size: 30)
            label.textAlignment = .center
            
            return label
        }()
        
        let rightMenuButton = {
            let button = UIButton(type: .system)
            button.tintColor = .black
            button.setImage(.verticalMenu, for: .normal)
            
            let habitInfo = UIAction(title: "습관 정보", handler: { _ in
                let reportHabitInfoViewController = ReportHabitInfoViewController()
                reportHabitInfoViewController.setData(self.getMonthData(), self.user?.alarmTime?.dateToString(format: "hh : mm a"))
                self.presentBottomSheet(viewController: reportHabitInfoViewController,
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
        imageCollectionViewController.setData(getHabitAchievementRate())
        imageCollectionViewController.didMove(toParent: self)
        
        return imageCollectionViewController
    }
    
    private func makeHabitAchievementLabelView() -> UILabel {
        let rate = UILabel()
        rate.text = "\(getHabitAchievementRate())%"
        rate.font = Pretendard.semiBold(size: 16)
        rate.textAlignment = .center
        
        return rate
    }

    private func makeGridView() -> VStackView {
        func getTheBoxView(_ index: Int,_ width: UInt = 56,_ height: UInt = 45) -> UIButton {
            guard let totalHabitInfItems = self.totalHabitInfItems else { return UIButton() }
            if totalHabitInfItems.count == 0 { return UIButton() }
            
            let boxView = UIButton(type: .system, primaryAction: .init(handler: { _ in
                if self.totalHabitInfItems![index].date?.dateToString(format: "MMdd") ?? "" <= Date().dateToString(format: "MMdd") && self.totalHabitInfItems![index].hasDone {
                    let reportHabitDetailViewController = ReportHabitDetailViewController()
                    reportHabitDetailViewController.setData(self.totalHabitInfItems?[index])
                    
                    self.presentBottomSheet(viewController: reportHabitDetailViewController, detents: [.large()])
                }
            }))
            boxView.layer.cornerRadius = 10
            boxView.clipsToBounds = true
            
            let label = UILabel()
            
            if totalHabitInfItems[index].date?.dateToString(format: "MMdd") ?? "" == Date().dateToString(format: "MMdd") {
                label.text = "오늘"
                label.font = Pretendard.bold(size: 18)
                label.textColor = .white
                boxView.addSubview(label)
                
                label.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.centerY.equalToSuperview()
                }
            }
            
            boxView.alpha = totalHabitInfItems[index].date?.dateToString(format: "MMdd") ?? "" <= Date().dateToString(format: "MMdd") ? 1 : 0.1
            if totalHabitInfItems[index].date?.dateToString(format: "MMdd") ?? "" == Date().dateToString(format: "MMdd") &&
                totalHabitInfItems[index].hasDone == false { // item의 날자가 오늘이고 습관 완료 안했을때 알파 값 낮춤
                boxView.alpha = 0.1
            }
            
            if totalHabitInfItems[index].date?.dateToString(format: "MMdd") ?? "" > Date().dateToString(format: "MMdd") ||
                totalHabitInfItems[index].hasDone { // item의 날자가 오늘보다 미래이거나 완료 했으면 했다는 색 표시
                boxView.backgroundColor = index == 0 ? .pobitGreen : .pobitRed
            } else { // 그 외에는 안했다는거
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
        let functionExecutedKey = "wasShownMessageBoxView"
        
        let label = BasePaddingLabel(padding: UIEdgeInsets(top: 7, left: 15, bottom: 7, right: 15))
        label.alpha = 0
        
        // 앱이 설치된 이후로 한번만 메세지를 보여주기 위함
        if UserDefaults.standard.bool(forKey: functionExecutedKey) == false {
            label.text = message
            label.textAlignment = .center
            label.font = Pretendard.regular(size: 16)
            label.backgroundColor = UIColor(hex: "#FFDADA")
            label.textColor = .pobitBlack
            
            UIView.animate(withDuration: 2,
                           delay: 0.5,
                           usingSpringWithDamping: 0.6,
                           initialSpringVelocity: 0.2,
                           options: .curveEaseInOut) {
                label.alpha = 1
            } completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    UIView.animate(withDuration: 2,
                                   delay: 0,
                                   usingSpringWithDamping: 0.6,
                                   initialSpringVelocity: 0.2,
                                   options: .curveEaseInOut) {
                        label.alpha = 0
                    }
                }
            }
            UserDefaults.standard.set(true, forKey: functionExecutedKey)
        }
        
        return label
    }
}

// MARK: - Data Helpers

extension ReportViewController {
    
    // 데이터 fetch 해주는데, lazy로 선언된 프로퍼티가 사용이 안되있으면 리로드가 불필요하다고 판단하여 조건문 처리.
    private func fetchData() {
        if user != nil {
            user = try? CoreDataManager.shared.fetchUser()
        }
        
        if totalHabitInfItems != nil {
            totalHabitInfItems = try? CoreDataManager.shared.fetchTotalHabitInfo()
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
    
    // 달성률 구하는 함수
    private func getHabitAchievementRate() -> Int {
        guard let totalHabitInfItems = totalHabitInfItems else { return 0 }
        
        var hasDoneCount: Double = 0.0
        totalHabitInfItems.forEach { habit in if habit.hasDone { hasDoneCount += 1.0 } }
        
        if hasDoneCount == 0.0 { return 0 }
        
        hasDoneCount = hasDoneCount / Double(totalHabitInfItems.count) * 100
        
        return Int(hasDoneCount)
    }
}

// MARK: - Types

extension ReportViewController {
    enum Check {
        case complete, fail, rest
    }
}
