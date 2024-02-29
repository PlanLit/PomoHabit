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
    
    var myPageTableView: UITableView!
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        setupNickName()
        setupEditButton()
        setupTableView()
        setupGrayBar()
        setupHabbitSituation()
        setupOvalView()
        setupGrayBar2()
        setupTotalAndDidDaysLabels()
    }
    
    // MARK: - 닉네임 UI
    
    func setupNickName() {
        let nicknameLabel = UILabel()
        nicknameLabel.text = "닉네임"
        nicknameLabel.textColor = .darkGray
        nicknameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        addSubview(nicknameLabel)
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(20)
        }
    }
    
    // MARK: - 수정버튼 UI
    
    func setupEditButton() {
        let editButton = UIButton(type: .system)
        editButton.setTitle("수정", for: .normal)
        editButton.setTitleColor(.black, for: .normal)
        editButton.backgroundColor = .clear
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        editButton.layer.borderWidth = 1
        editButton.layer.borderColor = UIColor.gray.cgColor
        editButton.layer.cornerRadius = 9
        addSubview(editButton)
        
        editButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.trailing.lessThanOrEqualToSuperview().offset(-20)
            make.width.equalTo(30)
            make.height.equalTo(20)
        }
    }
    
    // MARK: - DividerView
    
    func setupGrayBar() {
        let grayBarView = UIView()
        grayBarView.backgroundColor = UIColor.systemGray5
        addSubview(grayBarView)
        
        grayBarView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(60)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(7)
        }
    }
    
    // MARK: - 습관 진행 상태 UI
    
    func setupHabbitSituation() {
        let habbitSituationLabel = UILabel()
        habbitSituationLabel.text = "습관 진행 상태"
        habbitSituationLabel.textColor = .darkGray
        habbitSituationLabel.font = UIFont.boldSystemFont(ofSize: 20)
        addSubview(habbitSituationLabel)
        
        habbitSituationLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(90)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(20)
        }
    }
    
    // MARK: - layerView
    
    func setupOvalView() {
        let ovalView = UIView()
        ovalView.backgroundColor = .clear
        ovalView.layer.cornerRadius = 15
        ovalView.layer.borderWidth = 1
        ovalView.layer.borderColor = UIColor.systemGray4.cgColor
        ovalView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ovalView)
        
        ovalView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(120)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(80)
        }
    }
    
    // MARK: - DividerView
    
    func setupGrayBar2() {
        let grayBarView = UIView()
        grayBarView.backgroundColor = UIColor.systemGray5
        addSubview(grayBarView)
        
        grayBarView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(230)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(7)
        }
    }
    
    // MARK: - 습관 진행 상태 내용 StackView
    
    func setupTotalAndDidDaysLabels() {
        
        let totalDaysLabel = UILabel().setPrimaryColorLabel(text: "4일")
        
        let didDaysLabel = UILabel()
        didDaysLabel.text = "진행 일수"
        didDaysLabel.textColor = .darkGray
        didDaysLabel.font = UIFont.systemFont(ofSize: 13)
        didDaysLabel.translatesAutoresizingMaskIntoConstraints = false
       
        let totalMinutesLabel = UILabel().setPrimaryColorLabel(text: "5분")
        
        let didMinutesLabel = UILabel()
        didMinutesLabel.text = "진행 총시간"
        didMinutesLabel.textColor = .darkGray
        didMinutesLabel.font = UIFont.systemFont(ofSize: 13)
        didMinutesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let totalHabbitsLabel = UILabel().setPrimaryColorLabel(text: "0개")
        
        let didHabbitsLabel = UILabel()
        didHabbitsLabel.text = "완료한 습관수"
        didHabbitsLabel.textColor = .darkGray
        didHabbitsLabel.font = UIFont.systemFont(ofSize: 13)
        didHabbitsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let vStackView1 = VStackView(spacing: 3, alignment: .center, distribution: .equalSpacing, [totalDaysLabel, didDaysLabel])
        addSubview(vStackView1)
        
        vStackView1.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(140)
        }
        
        let vStackView2 = VStackView(spacing: 3, alignment: .center, distribution: .equalSpacing, [totalMinutesLabel, didMinutesLabel])
        addSubview(vStackView2)
        
        vStackView2.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(140)
        }
        
        let vStackView3 = VStackView(spacing: 3, alignment: .center, distribution: .equalSpacing, [totalHabbitsLabel, didHabbitsLabel])
        addSubview(vStackView3)
        
        vStackView3.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(140)
        }
        
        let hStackView = HStackView(spacing: 20, alignment: .center, distribution: .equalSpacing, [vStackView1, vStackView2, vStackView3])
        addSubview(hStackView)
        
        hStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(140)
            make.leading.equalToSuperview().offset(70)
            make.trailing.equalToSuperview().offset(-70)
        }
    }
    
    func setupTableView() {
        let topMargin: CGFloat = 350
        let tableViewFrame = CGRect(x: 0, y: topMargin, width: bounds.width, height: bounds.height - topMargin)
        myPageTableView = UITableView(frame: tableViewFrame, style: .plain)
        myPageTableView.separatorStyle = .none
        myPageTableView.dataSource = self
        myPageTableView.delegate = self
        myPageTableView.register(MyPageTableViewCell.self, forCellReuseIdentifier: "cell")
        addSubview(myPageTableView)
        
        myPageTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(topMargin)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - DataSource

extension MyPageView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myPageCellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyPageTableViewCell
        let model = myPageCellModels[indexPath.row]
        cell.textLabel?.text = model.title
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        cell.textLabel?.textColor = .darkGray
        
        return cell
    }
    
}

// MARK: - Delegate

extension MyPageView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
