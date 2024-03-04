//
//  MypageView.swift
//  PomoHabit
//
//  Created by 洪立妍 on 2/29/24.
//

import UIKit

import SnapKit

// MARK: - MyPageView

final class MyPageView: BaseView {
    
    // MARK: - Properties
    
    private lazy var myPageTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        return tableView
    }()
    
    private lazy var topMargin: CGFloat = 360
    
    // MARK: - 닉네임 UI
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("수정", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.cornerRadius = 9
        
        return button
    }()
    
    // MARK: - DividerView
    
    private let grayBar: UIView = {
        let bar = UIView()
        bar.backgroundColor = UIColor.systemGray5
        
        return bar
    }()
    
    // MARK: - 습관 진행 상태 UI
    
    private let habbitSituation: UILabel = {
        let label = UILabel()
        label.text = "습관 진행 상태"
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    // MARK: - layerView
    
    private let ovalView: UIView = {
        let ovalView = UIView()
        ovalView.backgroundColor = .clear
        ovalView.layer.cornerRadius = 15
        ovalView.layer.borderWidth = 1
        ovalView.layer.borderColor = UIColor.systemGray4.cgColor
        ovalView.translatesAutoresizingMaskIntoConstraints = false
        
        return ovalView
    }()
    
    // MARK: - DividerView
    
    private let grayBar2: UIView = {
        let bar = UIView()
        bar.backgroundColor = UIColor.systemGray5
        
        return bar
    }()
    
    
    // MARK: - 습관 진행 상태 내용 UI
    
    private lazy var totalDaysLabel: UILabel = {
        let label = UILabel().setPrimaryColorLabel(text: "4일")
        
        return label
    }()
    
    private lazy var didDaysLabel: UILabel = {
        let label = UILabel().makeMyPageLabel(text: "진행 일수")
        
        return label
    }()
    
    private lazy var totalMinutesLabel: UILabel = {
        let label = UILabel().setPrimaryColorLabel(text: "5분")
        
        return label
    }()
    
    private lazy var didMinutesLabel: UILabel = {
        let label = UILabel().makeMyPageLabel(text: "진행 총시간")
        
        return label
    }()
    
    private lazy var totalHabbitsLabel: UILabel = {
        let label = UILabel().setPrimaryColorLabel(text: "0개")
        
        return label
    }()
    
    private lazy var didHabbitsLabel: UILabel = {
        let label = UILabel().makeMyPageLabel(text: "완료한 습관수")
        
        return label
    }()
    
    
    // MARK: - 습관 진행 상태 내용 StackView
    
    private lazy var totalAndDidDaysLabels: UIView = {
        let vStackView1 = VStackView(spacing: 3, alignment: .center, distribution: .equalSpacing, [totalDaysLabel, didDaysLabel])
        let vStackView2 = VStackView(spacing: 3, alignment: .center, distribution: .equalSpacing, [totalMinutesLabel, didMinutesLabel])
        let vStackView3 = VStackView(spacing: 3, alignment: .center, distribution: .equalSpacing, [totalHabbitsLabel, didHabbitsLabel])
        
        let hStackView = HStackView(spacing: 20, alignment: .center, distribution: .equalSpacing, [vStackView1, vStackView2, vStackView3])
        addSubview(hStackView)
        
        return hStackView
    }()
    
    // MARK: - TableView
    
    private lazy var tableView: UITableView = {
        let topMargin: CGFloat = 360
        let tableViewFrame = CGRect(x: 0, y: topMargin, width: self.bounds.width, height: self.bounds.height - topMargin)
        let myPageTableView = UITableView(frame: tableViewFrame, style: .plain)
        myPageTableView.separatorStyle = .none
        myPageTableView.dataSource = self
        myPageTableView.delegate = self
        myPageTableView.register(MyPageTableViewCell.self, forCellReuseIdentifier: MyPageTableViewCell.reuseIdentifier)
        
        return myPageTableView
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout Helpers

extension MyPageView {
    private func setAddSubviews() {
        addSubViews([
            nickNameLabel,
            editButton,
            grayBar,
            habbitSituation,
            ovalView,
            grayBar2,
            totalAndDidDaysLabels,
            tableView
        ])
    }
    
    private func setupConstraints() {
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        editButton.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.top)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(30)
            make.height.equalTo(20)
        }
        
        grayBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(60)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(7)
        }
        
        habbitSituation.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(90)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        ovalView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(120)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(80)
        }
        
        grayBar2.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(230)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(7)
        }
        
        totalAndDidDaysLabels.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(140)
            make.leading.equalToSuperview().offset(70)
            make.trailing.equalToSuperview().offset(-70)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(topMargin)
            make.left.right.bottom.equalToSuperview()
        }
    }
}


// MARK: - UITableViewDataSource

extension MyPageView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myPageCellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTableViewCell.reuseIdentifier, for: indexPath) as? MyPageTableViewCell else {
            fatalError("Error")
        }
        let model = myPageCellModels[indexPath.row]
        cell.textLabel?.text = model.title
        cell.textLabel?.font = Pretendard.bold(size: 20)
        cell.textLabel?.textColor = .pobitStone2
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MyPageView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
