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
    
    private var currentMessages = [OnboardingModel(message: "안녕! 앱을 실행해줘서 고마워!", chatType: .receive),
                                   OnboardingModel(message: "나는 새로운 습관 형성을 도와줄 가이드야.", chatType: .receive),
                                   OnboardingModel(message: "어떤 습관을 만들고 싶어?", chatType: .receive),
                                   OnboardingModel(message: "수학 문제 풀기", chatType: .send),
                                   OnboardingModel(message: "무슨 요일에 할거야?", chatType: .receive),
                                   OnboardingModel(message: "", chatType: .send),
                                   OnboardingModel(message: "몇시에 할거야?", chatType: .receive),
                                   OnboardingModel(message: "6:00PM", chatType: .send)]

    private lazy var chattingTableView: UITableView = makeChattingTableView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        tableView.register(OnboardingChattingCell.self, forCellReuseIdentifier: "\(OnboardingChattingCell.self)")
        tableView.register(DaysTableViewCell.self, forCellReuseIdentifier: "\(DaysTableViewCell.self)")
        
        return tableView
    }
}

// MARK: - UITableViewDataSource

extension OnboardingChattingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 5 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(DaysTableViewCell.self)", for: indexPath) as? DaysTableViewCell else { return UITableViewCell() }
            
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(OnboardingChattingCell.self)", for: indexPath) as? OnboardingChattingCell else { return UITableViewCell() }
        cell.configureCell(with: currentMessages[indexPath.item])
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension OnboardingChattingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 5 {
            return 134
        }
        
        return 75
    }
}
