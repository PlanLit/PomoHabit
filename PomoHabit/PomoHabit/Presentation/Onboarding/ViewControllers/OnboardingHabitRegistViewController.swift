//
//  OnboardingHabitRegistViewController.swift
//  PomoHabit
//
//  Created by JiHoon K on 3/8/24.
//

import UIKit

// MARK: - OnboardingHabitRegistViewController

final class OnboardingHabitRegistViewController: BaseViewController {
    
    // MARK: - Data Properties
    
    private var habitName: String?
    private var daysButtonSelectionState: [Bool] = [false, false, false, false, false, false, false]
    private var habitStartTime: Date?
    
    // MARK: - Logic Properties
    
    private var currentMessages: [OnboardingChattingCellData] = []
    private var hasShownDaysCell = false
    private var hasTimePickerSelected = false
    
    // MARK: - UI Properties
    
    private lazy var chattingTableView: UITableView = makeChattingTableView()
    private lazy var habitTextFieldView: HStackView = makeHabitTextFieldView()
    private lazy var registButton: UIButton = makeRegistButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSelf()
        
        setAddSubviews()
        setAutoLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        sayHello()
    }
}

// MARK: - Layout Helpers

extension OnboardingHabitRegistViewController {
    private func setUpSelf() {
        view.backgroundColor = UIColor.pobitSkin
    }
    
    private func setAddSubviews() {
        view.addSubViews([chattingTableView, habitTextFieldView, registButton])
    }
    
    private func setAutoLayout() {
        chattingTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalTo(registButton.snp.top)
        }
        
        habitTextFieldView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.height.equalTo(58)
        }
        
        registButton.snp.makeConstraints { make in
            make.top.equalTo(chattingTableView.snp.bottom)
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(0)
        }
    }
}

// MARK: - Factory Methods

extension OnboardingHabitRegistViewController {
    private func makeChattingTableView() -> UITableView {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .pobitSkin
        tableView.allowsSelection = false
        
        return tableView
    }
    
    private func makeHabitTextFieldView() -> HStackView {
        let textField = {
            let textField = UITextField()
            textField.attributedPlaceholder = NSAttributedString(string: "습관 제목", attributes: [NSAttributedString.Key.foregroundColor: UIColor.pobitStone3])
            textField.addLeftPadding()
            textField.backgroundColor = .white
            textField.delegate = self
            
            return textField
        }()
    
        let submitButton = {
            let button = UIButton(type: .system, primaryAction: .init(handler: { _ in
                self.habitTextFieldView.isHidden = true
                self.view.endEditing(true)
            }))
            button.setTitle("확인", for: .normal)
            button.setTitleColor(.pobitWhite, for: .normal)
            button.backgroundColor = .pobitBlack
            button.snp.makeConstraints { make in
                make.width.equalTo(96)
            }
            
            return button
        }()
        
        let container = HStackView(spacing: 0, alignment: .fill, distribution: .fill, [
            textField,
            submitButton
        ])
        
        container.isHidden = true
        
        return container
    }
    
    private func makeRegistButton() -> UIButton {
        let button = UIButton(type: .system, primaryAction: .init(handler: { _ in
            if self.isUserInputComplete() {
                self.navigationController?.setViewControllers([TabBarController()], animated: true)
            }
        }))
        button.setTitle("등록하기", for: .normal)
        button.backgroundColor = .pobitRed
        button.tintColor = .white
        button.titleLabel?.font = Pretendard.medium(size: 24)
        
        return button
    }
    
    private func makeCountTimer(executionTargetNumber: Int = 1, withTimeInterval: TimeInterval = 0, action: @escaping () -> (), ended: @escaping () -> ()) -> Timer {
        var runCount = 0
        let timer = Timer.scheduledTimer(withTimeInterval: withTimeInterval, repeats: true) { timer in
            runCount += 1
            action()
            
            if runCount == executionTargetNumber {
                timer.invalidate()
                ended()
            }
        }
        
        return timer
    }
    
    private func makeOnboardingDaysButtonTableViewCell() -> OnboardingDaysButtonTableViewCell {
        let cell = OnboardingDaysButtonTableViewCell()
        cell.daysButtonSelectionState = daysButtonSelectionState
        cell.action = { inx, state in
            self.daysButtonSelectionState[inx] = state
            var trueCount = 0
            for state in self.daysButtonSelectionState {
                if state { trueCount += 1 }
            }
            if self.hasShownDaysCell == false && trueCount >= 5 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.addTableViewCellDataAndUpdate(.init(chatDirection: .incoming, message: "몇시에 할거야?"))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.addTableViewCellDataAndUpdate(.init(chatDirection: .outgoing, cellType: .time))
                    }
                }
                
                self.hasShownDaysCell = true
            }
            if trueCount >= 5 {
                self.registButton.backgroundColor = .pobitRed
            } else {
                self.registButton.backgroundColor = .gray
            }
        }
        
        return cell
    }
    
    private func makeOnboardingDatePickerTableViewCell(_ indexPath: IndexPath) -> OnboardingDatePickerTableViewCell {
        let cell = OnboardingDatePickerTableViewCell()
        cell.dateChangeEnded = { [weak self] date in
            if self?.habitStartTime == nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.addTableViewCellDataAndUpdate(.init(chatDirection: .incoming, message: "좋아 다 됬어! 우리 꼭 습관을 만들어보자!"))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self?.registButton.snp.updateConstraints({ make in
                            make.height.equalTo(82)
                        })
                        UIView.animate(withDuration: 0.6,
                                       delay: 0,
                                       usingSpringWithDamping: 0.6,
                                       initialSpringVelocity: 0.2,
                                       options: .curveEaseInOut) {
                            self?.view.layoutIfNeeded()
                        }
                        self?.addTableViewCellDataAndUpdate(.init(chatDirection: .incoming, message: "화이팅!!!"))
                    }
                }
            }
            self?.habitStartTime = date
        }
        
        return cell
    }
    
    private func makeOnboardingChattingTableViewCell(_ indexPath: IndexPath) -> OnboardingChattingTableViewCell {
        let cell = OnboardingChattingTableViewCell()
        cell.configureCell(with: currentMessages[indexPath.item])
        
        return cell
    }
}

// MARK: - Helpers

extension OnboardingHabitRegistViewController {
    // 처음 채팅뷰에 진입했을때 한번만 실행시켜야함.
    private func sayHello() {
        let messages: [OnboardingChattingCellData] = [.init(chatDirection: .incoming, cellType: .profilePicture),
                                                      .init(chatDirection: .incoming, message: "안녕! 앱을 실행해줘서 고마워!"),
                                                      .init(chatDirection: .incoming, message: "나는 새로운 습관 형성을 도와줄 가이드야."),
                                                      .init(chatDirection: .incoming, message: "어떤 습관을 만들고 싶어?")]
        
        var index = UnsentMessagesIndex(unsentMessagesCount: messages.count)
        
        DispatchQueue.main.async {
            self.addTableViewCellDataAndUpdate(messages[index.value])
            self.makeCountTimer(executionTargetNumber: messages.count - 1,
                                withTimeInterval: 2,
                                action: {
                self.addTableViewCellDataAndUpdate(messages[index.value])
            }, ended: {
                self.habitTextFieldView.isHidden = false
                self.habitTextFieldView.subviews.first?.becomeFirstResponder()
            }).fire()
        }
    }
    
    // 채팅 테이블뷰에 데이터와 함께 셀 추가 하는 함수
    private func addTableViewCellDataAndUpdate(_ message: OnboardingChattingCellData) {
        self.currentMessages.append(message)
        let indexPath = IndexPath(row: self.currentMessages.count - 1, section: 0)
        self.chattingTableView.insertRows(at: [indexPath], with: .fade)
        self.chattingTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    
    // 유저가 모든 데이터를 제대로 입력했는지 확인하는 함수
    private func isUserInputComplete() -> Bool {
        if habitName == nil { return false }
        if habitStartTime == nil { return false }
        
        var daysOnCount = 0
        _ = daysButtonSelectionState.map { state in
            if state { daysOnCount += 1 }
        }
        
        if daysOnCount < 5 { return false }
        
        return true
    }
}

// MARK: - UITableViewDataSource

extension OnboardingHabitRegistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch currentMessages[indexPath.row].cellType {
        case .profilePicture:
            return OnboardingProfilePictureTableViewCell()
        case .days:
            return makeOnboardingDaysButtonTableViewCell()
        case .time:
            return makeOnboardingDatePickerTableViewCell(indexPath)
        default:
            return makeOnboardingChattingTableViewCell(indexPath)
        }
    }
}

// MARK: - UITableViewDelegate

extension OnboardingHabitRegistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if currentMessages[indexPath.row].cellType == .days {
            return 102 + 25
        }
        
        return 44 + 25
    }
}

// MARK: - UITextFieldDelegate

extension OnboardingHabitRegistViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        habitName = textField.text
        
        addTableViewCellDataAndUpdate(.init(chatDirection: .outgoing, message: habitName, cellType: .title))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.addTableViewCellDataAndUpdate(.init(chatDirection: .incoming, message: "무슨 요일에 할거야? 5일 이상을 정해줘!"))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.addTableViewCellDataAndUpdate(.init(chatDirection: .outgoing, cellType: .days))
            }
        }
    }
}

// MARK: - Types

extension OnboardingHabitRegistViewController {
    /// 매번 호출 되기 전 마다 1씩 증가함 + 초기에 정한 unsentMessagesCount 값 보다는 안커짐 (Index out of range Error 방지)
    private struct UnsentMessagesIndex {
        private let unsentMessagesCount: Int
        private var _value: Int
        
        var value: Int {
            mutating get {
                if _value < unsentMessagesCount {
                    _value += 1
                }
                
                return _value
            }
        }
        
        init(unsentMessagesCount: Int, _value: Int = -1) {
            self.unsentMessagesCount = unsentMessagesCount
            self._value = _value
        }
    }
}
