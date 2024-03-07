//
//  OnboardingChattingViewController.swift
//  PomoHabit
//
//  Created by 최유리 on 2/29/24.
//

import UIKit

// MARK: - OnboardingChattingViewController

final class OnboardingChattingViewController: UIViewController {
    
    // Test Data
    var titleData = ""
    var buttonSelectionStates: [Bool] = [false, false, false, false, false, false, false]
    
    // MARK: - Properties
    
    private var unsentMessages: [OnboardingChattingCellData] = [OnboardingChattingCellData(chatDirection: .incoming, cellType: .profilePicture),
                                                                OnboardingChattingCellData(chatDirection: .incoming, message: "안녕! 앱을 실행해줘서 고마워!"),
                                                                OnboardingChattingCellData(chatDirection: .incoming, message: "나는 새로운 습관 형성을 도와줄 가이드야."),
                                                                OnboardingChattingCellData(chatDirection: .incoming, message: "어떤 습관을 만들고 싶어?"),
                                                                OnboardingChattingCellData(chatDirection: .outgoing, message: "수학문제 풀기", cellType: .title),
                                                                OnboardingChattingCellData(chatDirection: .incoming, message: "무슨 요일에 할거야?"),
                                                                OnboardingChattingCellData(chatDirection: .outgoing, cellType: .days),
                                                                OnboardingChattingCellData(chatDirection: .incoming, message: "몇시에 할거야?"),
                                                                OnboardingChattingCellData(chatDirection: .outgoing, message: "9:40PM에 할게!", cellType: .time),]
    
    private var currentMessages: [OnboardingChattingCellData] = []

    private var unsentMessageIndex = UnsentMessagesIndex(unsentMessagesCount: 8) // unsentMessages를 가리키는 인덱스 변수
    
    private lazy var chattingTableView: UITableView = makeChattingTableView()
    
    private lazy var habbitTextFieldView: HStackView = makeHabitTectFieldView()
    
    private var hasShownDaysCell = false
    
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

extension OnboardingChattingViewController {
    private func setUpSelf() {
        view.backgroundColor = UIColor.pobitSkin
    }
    
    private func setAddSubviews() {
        view.addSubViews([chattingTableView, habbitTextFieldView])
    }
    
    private func setAutoLayout() {
        chattingTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        habbitTextFieldView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
            make.trailing.equalToSuperview()
            make.height.equalTo(58)
        }
    }
}

// MARK: - Factory Methods

extension OnboardingChattingViewController {
    private func makeChattingTableView() -> UITableView {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .pobitSkin
        tableView.allowsSelection = false
        
        return tableView
    }
    
    private func makeHabitTectFieldView() -> HStackView {
        let textField = {
            let textField = UITextField()
            textField.attributedPlaceholder = NSAttributedString(string: "내용을 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor.pobitStone3])
            textField.addLeftPadding()
            textField.backgroundColor = .white
            textField.delegate = self
            
            return textField
        }()
    
        let submitButton = {
            let button = UIButton(type: .system, primaryAction: .init(handler: { _ in
                self.habbitTextFieldView.isHidden = true
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
    
    private func makeCountTimer(_ number: Int,_ action: @escaping () -> (),_ ended: @escaping () -> ()) -> Timer {
        var runCount = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            runCount += 1
            action()
            
            if runCount == number {
                timer.invalidate()
                ended()
            }
        }
        
        return timer
    }
}

// MARK: - Helpers

extension OnboardingChattingViewController {
    private func sayHello() {
        let messages: [OnboardingChattingCellData] = [.init(chatDirection: .incoming, cellType: .profilePicture),
                                                      .init(chatDirection: .incoming, message: "안녕! 앱을 실행해줘서 고마워!"),
                                                      .init(chatDirection: .incoming, message: "나는 새로운 습관 형성을 도와줄 가이드야."),
                                                      .init(chatDirection: .incoming, message: "어떤 습관을 만들고 싶어?")]
        
        var index = UnsentMessagesIndex(unsentMessagesCount: messages.count)
        
        RunLoop.current.add(makeCountTimer(messages.count, {
            self.addTableViewCellDataAndUpdate(messages[index.value])
        }, {
            self.habbitTextFieldView.isHidden = false
            self.habbitTextFieldView.subviews.first?.becomeFirstResponder()
        }), forMode: .common)
    }
    
    private func addTableViewCellDataAndUpdate(_ message: OnboardingChattingCellData) {
        self.currentMessages.append(message)
        let indexPath = IndexPath(row: self.currentMessages.count - 1, section: 0)
        self.chattingTableView.insertRows(at: [indexPath], with: .fade)
        self.chattingTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension OnboardingChattingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if currentMessages[indexPath.row].cellType == .days {
            let cell = OnboardingDaysButtonTableViewCell()
            cell.buttonSelectionStates = buttonSelectionStates
            cell.action = { inx, state in
                self.buttonSelectionStates[inx] = state
                
                var trueCount = 0
                for state in self.buttonSelectionStates {
                    if state { trueCount += 1 }
                }
                if self.hasShownDaysCell == false && trueCount >= 5 {
                    DispatchQueue.main.async {
                        self.addTableViewCellDataAndUpdate(.init(chatDirection: .incoming, message: "몇시에 할거야?"))
                    }
                    
                    self.hasShownDaysCell = true
                }
            }
            
            return cell
        }
        
        if currentMessages[indexPath.row].cellType == .profilePicture {
            let cell = OnboardingProfilePictureTableViewCell()
            
            return cell
        }
        
        let cell = OnboardingChattingTableViewCell()
        cell.configureCell(with: currentMessages[indexPath.item])
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension OnboardingChattingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if currentMessages[indexPath.row].cellType == .days {
            return 102 + 30
        }
        
        return 44 + 30
    }
}

// MARK: - UITextFieldDelegate

extension OnboardingChattingViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        titleData = textField.text ?? ""
        
        addTableViewCellDataAndUpdate(.init(chatDirection: .outgoing, message: titleData, cellType: .title))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.addTableViewCellDataAndUpdate(.init(chatDirection: .incoming, message: "무슨 요일에 할거야? 5일 이상을 정해줘!"))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.addTableViewCellDataAndUpdate(.init(chatDirection: .outgoing, cellType: .days))
            }
        }
    }
}

// MARK: - Types

extension OnboardingChattingViewController {
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
