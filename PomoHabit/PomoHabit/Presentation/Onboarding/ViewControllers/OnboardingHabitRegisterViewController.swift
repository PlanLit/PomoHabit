//
//  OnboardingHabitRegistViewController.swift
//  PomoHabit
//
//  Created by JiHoon K on 3/8/24.
//

import UIKit

// MARK: - OnboardingHabitRegistViewController

final class OnboardingHabitRegisterViewController: BaseViewController {
    
    // MARK: - Data Properties
    
    private var nickname: String?
    private var habitTitle: String?
    private var daysButtonSelectionState: [Bool] = [false, false, false, false, false, false, false]
    private var habitAlarmTime: Date?
    
    // MARK: - Logic Properties
    
    private var currentMessages: [OnboardingChattingCellData] = []
    private var hasShownDaysCell = false
    private var hasTimePickerSelected = false
    
    // MARK: - UI Properties
    
    private lazy var chattingTableView: UITableView = makeChattingTableView()
    private lazy var habitTextFieldView: HStackView = makeHabitTextFieldView()
    private lazy var textFieldDoneButton: UIButton = makeTextFieldDoneButton()
    private lazy var registerButton: UIButton = makeRegisterButton()
    
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Layout Helpers

extension OnboardingHabitRegisterViewController {
    private func setUpSelf() {
        view.backgroundColor = UIColor.pobitSkin
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setAddSubviews() {
        view.addSubViews([chattingTableView, habitTextFieldView, registerButton])
    }
    
    private func setAutoLayout() {
        chattingTableView.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
            make.bottom.equalTo(registerButton.snp.top)
        }
        
        habitTextFieldView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
            make.height.equalTo(58)
        }
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(chattingTableView.snp.bottom)
            make.trailing.bottom.leading.equalToSuperview()
            make.height.equalTo(0)
        }
    }
}

// MARK: - Factory Methods

extension OnboardingHabitRegisterViewController {
    private func makeChattingTableView() -> UITableView {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .pobitSkin
        tableView.allowsSelection = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tableView.addGestureRecognizer(tapGesture)
        
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
        
        let container = HStackView(spacing: 0, alignment: .fill, distribution: .fill, [
            textField,
            textFieldDoneButton
        ])
        
        container.isHidden = true
        
        return container
    }
    
    private func makeTextFieldDoneButton() -> UIButton {
        let button = UIButton(type: .system, primaryAction: .init(handler: { _ in
            self.habitTextFieldView.isHidden = true
            self.view.endEditing(true)
            self.addTableViewCellDataAndUpdate(.init(chatDirection: .outgoing, message: self.habitTitle, cellType: .title))
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.addTableViewCellDataAndUpdate(.init(chatDirection: .incoming, message: "무슨 요일에 할 거야? 5일 이상을 정해줘!"))
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.addTableViewCellDataAndUpdate(.init(chatDirection: .outgoing, cellType: .days))
                }
            }
        }))
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.pobitWhite, for: .normal)
        button.backgroundColor = .gray
        button.isUserInteractionEnabled = false
        button.snp.makeConstraints { make in
            make.width.equalTo(96)
        }
        
        return button
    }
    
    private func makeRegisterButton() -> UIButton {
        let button = UIButton(type: .system, primaryAction: .init(handler: { _ in
            self.saveData()
            self.navigationController?.setViewControllers([TabBarController()], animated: true)
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
        cell.setData(daysButtonSelectionState) { inx, state in
            self.daysButtonSelectionState[inx] = state
            var trueCount = 0
            for state in self.daysButtonSelectionState {
                if state { trueCount += 1 }
            }
            if self.hasShownDaysCell == false && trueCount >= 5 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.addTableViewCellDataAndUpdate(.init(chatDirection: .incoming, message: "몇 시에 할 거야?"))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.addTableViewCellDataAndUpdate(.init(chatDirection: .outgoing, cellType: .time))
                    }
                }
                self.hasShownDaysCell = true
            }
            self.fetchRegisterButtonState()
        }
        
        return cell
    }
    
    private func makeOnboardingDatePickerTableViewCell(_ indexPath: IndexPath) -> OnboardingDatePickerTableViewCell {
        let cell = OnboardingDatePickerTableViewCell()
        cell.setData(habitAlarmTime ?? Date(timeIntervalSinceReferenceDate: .zero)) { [weak self] date in
            if self?.habitAlarmTime == nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.addTableViewCellDataAndUpdate(.init(chatDirection: .incoming, message: "좋아 다 됐어! 우리 꼭 습관을 만들어보자!"))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self?.registerButton.snp.updateConstraints({ make in
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
                        self?.fetchRegisterButtonState()
                    }
                }
            }
            self?.habitAlarmTime = date
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

extension OnboardingHabitRegisterViewController {
    // 처음 채팅뷰에 진입했을때 한번만 실행시켜야함.
    private func sayHello() {
        let messages: [OnboardingChattingCellData] = [.init(chatDirection: .incoming, cellType: .profilePicture),
                                                      .init(chatDirection: .incoming, message: "안녕 \(nickname ?? "")!"),
                                                      .init(chatDirection: .incoming, message: "습관 만들기 앱 PomoHabit에 온 것을 환영해!"),
                                                      .init(chatDirection: .incoming, message: "나는 새로운 습관 형성을 도와줄 가이드야!"),
                                                      .init(chatDirection: .outgoing, message: "안녕~"),
                                                      .init(chatDirection: .outgoing, message: "습관 만들기 앱이라고 들었는데?"),
                                                      .init(chatDirection: .incoming, message: "맞아!"),
                                                      .init(chatDirection: .incoming, message: "PomoHabit은 첫날 5분을 시작으로"),
                                                      .init(chatDirection: .incoming, message: "매일 1분씩 증가!"),
                                                      .init(chatDirection: .incoming, message: "21일 동안 최소 하나의 습관을"),
                                                      .init(chatDirection: .incoming, message: "만들 수 있도록 도와주는 앱이야!"),
                                                      .init(chatDirection: .incoming, message: "어떤 습관을 만들고 싶어?")]
        
        var index = UnsentMessagesIndex(unsentMessagesCount: messages.count)
        
        DispatchQueue.main.async {
            self.addTableViewCellDataAndUpdate(messages[index.value])
            self.makeCountTimer(executionTargetNumber: messages.count - 1,
                                withTimeInterval: 2,
                                action: { // messages.count - 1 만큼 실행되는 블록
                self.addTableViewCellDataAndUpdate(messages[index.value])
            }, ended: { // 마지막에 한번 실행되는 블록
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.habitTextFieldView.isHidden = false
                    self.habitTextFieldView.subviews.first?.becomeFirstResponder()
                }
            }).fire()
        }
    }
    
    // 채팅 테이블뷰에 데이터와 함께 셀 추가 하는 함수
    private func addTableViewCellDataAndUpdate(_ message: OnboardingChattingCellData) {
        currentMessages.append(message)
        let indexPath = IndexPath(row: currentMessages.count - 1, section: 0)
        chattingTableView.insertRows(at: [indexPath], with: .fade)
        chattingTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    // 이 함수가 호출 됬을때의 데이터 상태에따라 등록하기 버튼 뷰 패치
    private func fetchRegisterButtonState() {
        func isUserInputComplete() -> Bool { // 유저가 모든 데이터를 제대로 입력했는지 확인하는 함수
            if habitTitle == nil { return false }
            if habitAlarmTime == nil { return false }
            var daysOnCount = 0
            for state in daysButtonSelectionState {
                if state { daysOnCount += 1 }
            }
            if daysOnCount < 5 { return false }
            
            return true
        }
        
        DispatchQueue.main.async {
            if isUserInputComplete() {
                self.registerButton.backgroundColor = .pobitRed
                self.registerButton.isUserInteractionEnabled = true
            } else {
                self.registerButton.backgroundColor = .gray
                self.registerButton.isUserInteractionEnabled = false
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension OnboardingHabitRegisterViewController: UITableViewDataSource {
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

extension OnboardingHabitRegisterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch currentMessages[indexPath.row].cellType {
        case .days:
            return 102 + 10
        case .profilePicture:
            return 73
        default:
            return 44 + 10
        }
    }
}

// MARK: - UITextFieldDelegate

extension OnboardingHabitRegisterViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        habitTitle = textField.text
        
        if textField.text != "" {
            textFieldDoneButton.backgroundColor = .pobitRed
            textFieldDoneButton.isUserInteractionEnabled = true
        } else {
            textFieldDoneButton.backgroundColor = .gray
            textFieldDoneButton.isUserInteractionEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Keyboard Notification

extension OnboardingHabitRegisterViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + habitTextFieldView.frame.height, right: 0)
        chattingTableView.contentInset = contentInset
        chattingTableView.scrollIndicatorInsets = contentInset
        chattingTableView.scrollToRow(at: IndexPath(row: currentMessages.count-1, section: 0), at: .bottom, animated: true)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        chattingTableView.contentInset = .zero
        chattingTableView.scrollIndicatorInsets = .zero
    }
}

// MARK: - Action Helpers

extension OnboardingHabitRegisterViewController {
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Data Helpers

extension OnboardingHabitRegisterViewController {
    func setData(_ nickname: String?) {
        self.nickname = nickname
    }
    
    private func convertDataForCoreData() -> (nickname: String, targetHabit: String, targetDate: String, alarmTime: Date, whiteNoiseType: String?) {
        // 무슨 요일
        var targetDate = ""
        let daysAll = ["월", "화", "수", "목", "금", "토", "일"]
        for i in 0..<daysButtonSelectionState.count {
            if daysButtonSelectionState[i] {
                targetDate += daysAll[i] + ","
            }
        }
        if targetDate.last == "," { targetDate.removeLast() }
        
        return (nickname: nickname ?? "",
                targetHabit: habitTitle ?? "",
                targetDate: targetDate,
                alarmTime: habitAlarmTime ?? Date(),
                whiteNoiseType: "배경음을 선택해보세요!")
    }
    
    private func saveData() {
        let data = convertDataForCoreData()
        
        CoreDataManager.shared.createUser(nickname: data.nickname, targetHabit: data.targetHabit, targetDate: data.targetDate, alarmTime: data.alarmTime, whiteNoiseType: data.whiteNoiseType)
        
        CoreDataManager.shared.setMockupTotalHabitInfo(targetDate: data.targetDate)
    }
}

// MARK: - Types

extension OnboardingHabitRegisterViewController {
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
