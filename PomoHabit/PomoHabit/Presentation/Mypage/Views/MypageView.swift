//
//  MypageView.swift
//  PomoHabit
//
//  Created by 洪立妍 on 3/5/24.
//

import UIKit

import SnapKit

// MARK: - MyPageView

final class MyPageView: BaseView {
    
    // MARK: - Properties
    
    private let pobitNavigationBarView = PobitNavigationBarView(title: "마이페이지", viewType: .plain)
    
    // MARK: - 닉네임 UI
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.textColor = .pobitStone2
        label.font = Pretendard.bold(size: 20)
        
        return label
    }()
    
    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("수정", for: .normal)
        button.setTitleColor(.pobitStone2, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = Pretendard.regular(size: 15)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.pobitStone4.cgColor
        button.layer.cornerRadius = 9
        
        return button
    }()
    
    // MARK: - DividerView
    
    private let grayBar: UIView = {
        let bar = UIView()
        bar.backgroundColor = .pobitStone4
        
        return bar
    }()
    
    // MARK: - 습관 진행 상태 UI
    
    private let habbitSituationLabel: UILabel = {
        let label = UILabel()
        label.text = "습관 진행 상태"
        label.textColor = .pobitStone2
        label.font = Pretendard.bold(size: 20)
        
        return label
    }()
    
    // MARK: - layerView
    
    private let ovalView: UIView = {
        let ovalView = UIView()
        ovalView.backgroundColor = .clear
        ovalView.layer.cornerRadius = 15
        ovalView.layer.borderWidth = 1
        ovalView.layer.borderColor = UIColor.pobitStone4.cgColor
        ovalView.translatesAutoresizingMaskIntoConstraints = false
        
        return ovalView
    }()
    
    // MARK: - DividerView
    
    private let grayBar2: UIView = {
        let bar = UIView()
        bar.backgroundColor = .pobitStone4
        
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
        let vStackView1 = VStackView(spacing: 6, alignment: .center, distribution: .equalSpacing, [totalDaysLabel, didDaysLabel])
        let vStackView2 = VStackView(spacing: 6, alignment: .center, distribution: .equalSpacing, [totalMinutesLabel, didMinutesLabel])
        let vStackView3 = VStackView(spacing: 6, alignment: .center, distribution: .equalSpacing, [totalHabbitsLabel, didHabbitsLabel])
        let hStackView = HStackView(spacing: 20, alignment: .center, distribution: .equalSpacing, [vStackView1, vStackView2, vStackView3])
        addSubview(hStackView)
        
        return hStackView
    }()
    
    // MARK: - TableView
    
    private lazy var tableView: UITableView = {
        let myPageTableView = UITableView(frame: .zero, style: .plain)
        myPageTableView.separatorStyle = .singleLine
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
            pobitNavigationBarView,
            nickNameLabel,
            editButton,
            grayBar,
            habbitSituationLabel,
            ovalView,
            grayBar2,
            totalAndDidDaysLabels,
            tableView
        ])
    }
    
    private func setupConstraints() {
        pobitNavigationBarView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(58)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(85)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(LayoutLiterals.minimumHorizontalSpacing)
        }
        
        editButton.snp.makeConstraints { make in
            make.centerY.equalTo(nickNameLabel)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(42)
            make.height.equalTo(28)
        }
        
        grayBar.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(LayoutLiterals.upperPrimarySpacing)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(10)
        }
        
        habbitSituationLabel.snp.makeConstraints { make in
            make.top.equalTo(grayBar.snp.bottom).offset(34)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(LayoutLiterals.minimumHorizontalSpacing)
        }
        
        ovalView.snp.makeConstraints { make in
            make.top.equalTo(habbitSituationLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(LayoutLiterals.minimumHorizontalSpacing)
            make.height.equalTo(83)
        }
        
        grayBar2.snp.makeConstraints { make in
            make.top.equalTo(ovalView.snp.bottom).offset(LayoutLiterals.lowerPrimarySpacing)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(10)
        }
        
        totalAndDidDaysLabels.snp.makeConstraints { make in
            make.top.equalTo(ovalView.snp.top).offset(17)
            make.leading.trailing.equalTo(ovalView).inset(35)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(grayBar2.snp.top).offset(LayoutLiterals.upperPrimarySpacing)
            make.left.right.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(LayoutLiterals.minimumHorizontalSpacing)
            make.right.equalToSuperview().inset(LayoutLiterals.minimumHorizontalSpacing)
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
        cell.textLabel?.font = Pretendard.regular(size: 20)
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

// MARK: - Method

extension MyPageView {
    func updateTotalMinutesLabel(_ text: String) {
        totalMinutesLabel.text = text
    }
    
    func updateTotalDaysLabel(_ text: String) {
        totalDaysLabel.text = text
    }
}
