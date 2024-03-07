//
//  OnboardingChattingViewController.swift
//  PomoHabit
//
//  Created by 최유리 on 2/29/24.
//

import UIKit

// MARK: - OnboardingChattingViewController

final class OnboardingChattingViewController: UIViewController {
    
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
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSelf()
        
        setAddSubviews()
        setAutoLayout()
    }
}

// MARK: - Layout Helpers

extension OnboardingChattingViewController {
    private func setUpSelf() {
        view.backgroundColor = UIColor.pobitSkin
    }
    
    private func setAddSubviews() {
        view.addSubview(chattingTableView)
    }
    
    private func setAutoLayout() {
        chattingTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
        
        // Test
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchTest))
        tableView.isUserInteractionEnabled = true
        tableView.addGestureRecognizer(tapGesture)
        
        return tableView
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

// MARK: - Test

extension OnboardingChattingViewController {
    func insertNewRowInTableView() {
        let indexPath = IndexPath(row: currentMessages.count - 1, section: 0)
        chattingTableView.insertRows(at: [indexPath], with: .fade)
        chattingTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    func onAddNewItemTapped() {
        let newItem = unsentMessages[unsentMessageIndex.value]
        currentMessages.append(newItem)
    }
    
    @objc private func touchTest() {
        onAddNewItemTapped()
        insertNewRowInTableView()
    }
}
