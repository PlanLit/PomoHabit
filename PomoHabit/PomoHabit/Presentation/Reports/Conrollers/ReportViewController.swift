//
//  ReportViewController.swift
//  PomoHabit
//
//  Created by JiHoon K on 2/27/24.
//

import UIKit

// MARK: - ReportViewController

final class ReportViewController: BaseViewController, BottomSheetPresentable {
    
    // MARK: - Properties
    
    private let todayDate = { // 오늘 날짜 정수
        let currentDate = Date()
        let calendar = Calendar.current
        
        return calendar.component(.day, from: currentDate)
    }()
    
    private lazy var headerView: HStackView = makeHeaderView()
    
    private lazy var imageCollectionViewController: ReportImageCollectionViewController = makeImageCollectionViewController()
    
    private lazy var calendarNaviView: VStackView = makeCalendarNaviView()
    
    private lazy var gridView: VStackView = makeGridView(31) // 월마다 바뀌는 일 수 주입
    
    private lazy var messageBoxView: UILabel = makeMessageBoxView("모두 완료하면 토마토가 웃는 얼굴이 돼요")
    
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
            headerView,
            calendarNaviView,
            imageCollectionViewController.view,
            gridView,
            messageBoxView
        ])
    }
    
    private func setAutoLayout() {
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(LayoutLiterals.minimumHorizontalSpacing)
            make.right.equalTo(-LayoutLiterals.minimumHorizontalSpacing)
            make.height.equalTo(55)
        }
        
        imageCollectionViewController.view.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        
        calendarNaviView.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionViewController.view.snp.bottom).offset(LayoutLiterals.upperPrimarySpacing)
            make.left.equalToSuperview().offset(35)
            make.right.equalToSuperview().offset(-35)
            make.height.equalTo(55)
        }
        
        gridView.snp.makeConstraints { make in
            make.top.equalTo(calendarNaviView.snp.bottom).offset(LayoutLiterals.upperPrimarySpacing)
            make.left.right.equalToSuperview()
            make.height.equalTo(400)
        }
        
        messageBoxView.snp.makeConstraints { make in
            make.height.equalTo(35)
            make.top.equalTo(gridView.snp.bottom).offset(LayoutLiterals.upperPrimarySpacing)
            make.right.equalTo(view.snp.right).offset(-LayoutLiterals.minimumHorizontalSpacing)
            make.left.equalTo(view.snp.left).offset(LayoutLiterals.minimumHorizontalSpacing)
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
            button.overrideUserInterfaceStyle = .dark
            
            let habitInfo = UIAction(title: "습관 정보", handler: { _ in
                self.presentBottomSheet(rootView: ReportHabitInfoView(), detents: [.medium()])
            })
            
            let habitEdit = UIAction(title: "습관 변경", handler: { _ in
                self.presentBottomSheet(rootView: ReportHabitEditView(), detents: [.large()])
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
    
    private func makeCalendarNaviView() -> VStackView {
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
            label.textColor = .darkGray
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
        
        return VStackView(spacing: CGFloat(LayoutLiterals.upperPrimarySpacing), alignment: .fill, [
            HStackView(alignment: .center, [
                leftButton,
                centerTitle,
                rightButton,
            ]),
            bottomLine
        ])
    }

    private func makeGridView(_ days: Int) -> VStackView {
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
        
        let gridView = VStackView(spacing: 0, alignment: .center, [
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
        gridView.addArrangedSubview(
            HStackView([
                getTheBoxView(29, .complete),
                getTheBoxView(30, .complete),
                getTheBoxView(31, .complete),
            ])
        )
        
        gridView.backgroundColor = UIColor(red: 253, green: 249, blue: 249, alpha: 1)
        
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

// MARK: - Types

extension ReportViewController {
    enum Check {
        case complete, fail, rest
    }
}
