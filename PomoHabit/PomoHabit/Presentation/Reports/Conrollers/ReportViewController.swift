//
//  ReportViewController.swift
//  PomoHabit
//
//  Created by JiHoon K on 2/27/24.
//

import UIKit

import SnapKit

// MARK: - ReportViewController

final class ReportViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let todayDate = { // 오늘 날짜 정수
        let currentDate = Date()
        let calendar = Calendar.current
        
        return calendar.component(.day, from: currentDate)
    }()
    
    private var headerView: HStackView?
    
    private var calendarNaviView: VStackView?
    
    private var imageCollectionViewController: ReportImageCollectionViewController?
    
    private var gridView: VStackView?
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpHeaderView()
        setUpImageCollectionViewController()
        setUpCalendarNaviView()
        setUpGridView(31) // 월마다 바뀌는 일 수 주입
        
        setAddSubviews()
        setAutoLayout()
    }
}

// MARK: - Layout Helpers

extension ReportViewController {
    private func setAddSubviews() {
        guard let headerView = headerView else {return}
        guard let imageCollectionViewController = imageCollectionViewController else {return}
        guard let calendarNaviView = calendarNaviView else {return}
        guard let gridView = gridView else {return}
        
        addChild(imageCollectionViewController)
        
        view.addSubViews([
            headerView,
            calendarNaviView,
            imageCollectionViewController.view,
            gridView
        ])
    }
    
    private func setAutoLayout() {
        guard let headerView = headerView else {return}
        guard let imageCollectionViewController = imageCollectionViewController else {return}
        guard let calendarNaviView = calendarNaviView else {return}
        guard let gridView = gridView else {return}
        
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(55)
        }
        
        imageCollectionViewController.view.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        
        calendarNaviView.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionViewController.view.snp.bottom)
            make.left.equalToSuperview().offset(35)
            make.right.equalToSuperview().offset(-35)
            make.height.equalTo(55)
        }
        
        gridView.snp.makeConstraints { make in
            make.top.equalTo(calendarNaviView.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
            make.height.equalTo(400)
        }
    }
}

// MARK: - SetUpViews

extension ReportViewController {
    
    // MARK: - HeaderView
    
    private func setUpHeaderView() {
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
            button.overrideUserInterfaceStyle = .dark
            
            let habitInfo = UIAction(title: "습관 정보", handler: { _ in
                self.present(ReportHabitInfoViewController(), animated: true)
            })
            
            let habitEdit = UIAction(title: "습관 변경", handler: { _ in
                self.present(ReportHabitEditViewController(), animated: true)
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
        
        headerView = HStackView([
            blankView,
            titleLabel,
            rightMenuButton
        ])
    }
    
    // MARK: - ImageCollectionViewController
    
    private func setUpImageCollectionViewController() {
        let layout = UICollectionViewFlowLayout()
        imageCollectionViewController = ReportImageCollectionViewController(collectionViewLayout: layout)
        imageCollectionViewController?.didMove(toParent: self)
    }
    
    // MARK: - CalendarNaviView
    
    private func setUpCalendarNaviView() {
        let leftButton = {
            let button = UIButton(type: .system, primaryAction: .init(handler: { _ in
                print("leftButton")
            }))
            
            button.setImage(.arrowLeft, for: .normal)
            button.tintColor = .black
            
            return button
        }()
        
        let centerTitle = {
            let label = UILabel()
            label.font = Pretendard.bold(size: 20)
            label.textColor = .darkText
            label.text = "1월"
            
            return label
        }()
        
        let rightButton = {
            let button = UIButton(type: .system, primaryAction: .init(handler: { _ in
                print("rightButton")
            }))
            
            button.setImage(.arrowRight, for: .normal)
            button.tintColor = .black
            
            return button
        }()
        
        let bottomLine = {
            let bottomLine = UIView()
            bottomLine.backgroundColor = .lightGray
            bottomLine.snp.makeConstraints { make in
                make.height.equalTo(0.5)
            }
            return bottomLine
        }()
        
        calendarNaviView = VStackView(alignment: .fill, [
            HStackView(alignment: .center, [
                leftButton,
                centerTitle,
                rightButton,
            ]),
            bottomLine
        ])
    }
    
    // MARK: - GridView

    private func setUpGridView(_ days: Int) {
        gridView = VStackView(spacing: 0, alignment: .center, [
            HStackView([
                getTheBoxView(1, .complete),
                getTheBoxView(2, .complete),
                getTheBoxView(3, .complete),
            ]),
            HStackView([
                getTheBoxView(4, .fail),
                getTheBoxView(5, .fail),
                getTheBoxView(6, .complete),
                getTheBoxView(7, .complete),
                getTheBoxView(8, .complete),
            ]),
            HStackView([
                getTheBoxView(9, .complete),
                getTheBoxView(10, .complete),
                getTheBoxView(11, .complete),
                getTheBoxView(12, .complete),
                getTheBoxView(13, .complete),
            ]),
            HStackView([
                getTheBoxView(14, .complete),
                getTheBoxView(15, .complete),
                getTheBoxView(16, .complete),
                getTheBoxView(17, .rest),
                getTheBoxView(18, .rest),
            ]),
            HStackView([
                getTheBoxView(19, .rest),
                getTheBoxView(20, .complete),
                getTheBoxView(21, .complete),
                getTheBoxView(22, .complete),
                getTheBoxView(23, .complete),
            ]),
            HStackView([
                getTheBoxView(24, .complete),
                getTheBoxView(25, .complete),
                getTheBoxView(26, .complete),
                getTheBoxView(27, .complete),
                getTheBoxView(28, .complete),
            ]),
        ])
        
        // 월별 마다 이거 조정 필요
        gridView?.addArrangedSubview(
            HStackView([
                getTheBoxView(29, .complete),
                getTheBoxView(30, .complete),
                getTheBoxView(31, .complete),
            ])
        )
        
        gridView?.backgroundColor = UIColor(red: 253/255, green: 249/255, blue: 249/255, alpha: 0.1)
        
        func getTheBoxView(_ day: Int,_ state: Check) -> UIButton {
            let boxView = {
                let boxView = UIButton(type: .system, primaryAction: .init(handler: { _ in
                    print("day: \(day)")
                    print()
                }))
                
                boxView.backgroundColor = .pobitRed
                boxView.layer.cornerRadius = 10
                boxView.alpha = day <= todayDate ? 1 : 0.1
                
                boxView.snp.makeConstraints { make in
                    make.width.equalTo(62)
                    make.height.equalTo(50)
                }
                
                return boxView
            }()
            
            switch state {
            case .complete:
                boxView.backgroundColor = day <= 3 ? .pobitGreen : .pobitRed
            case .fail:
                boxView.backgroundColor = .pobitStone2
            case .rest:
                boxView.backgroundColor = .white
            }
             
            return boxView
        }
    }
}

// MARK: - Types

extension ReportViewController {
    enum Check {
        case complete, fail, rest
    }
}
