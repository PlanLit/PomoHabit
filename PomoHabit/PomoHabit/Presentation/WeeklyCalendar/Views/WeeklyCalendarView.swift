//
//  WeeklyCalendarView.swift
//  PomoHabit
//
//  Created by 원동진 on 2/27/24.
//

import UIKit

import SnapKit

// MARK: - WeeklyCalendarView

class WeeklyCalendarView: BaseView {
    
    // MARK: - Properties
    
    let days = ["월","화","수","목","금","토","일"]
    
    let dates = ["26","27","28","29","1","2","3"] // 임시
    
    let habbitStates = [HabbitState.done,HabbitState.doNot,HabbitState.done,HabbitState.notStart,HabbitState.notStart,HabbitState.notStart,HabbitState.notStart]
    
    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        
        return scrollView
    }()
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "주간 캘린더"
        label.font = Pretendard.pretendardBold(size: 26)
        label.textColor = UIColor.pobitBlack
        
        return label
    }()
    
    private lazy var todayLabel : BasePaddingLabel = {
        let label = BasePaddingLabel(padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        label.text = "Today"
        label.font = Pretendard.pretendardBold(size: 12)
        label.textColor = .white
        label.backgroundColor = UIColor.pobitRed2
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        
        return label
    }()
    
    private lazy var todayDateLabel : UILabel = {
        let label = UILabel()
        label.text = Date().monthAndDaytoString()
        label.font = Pretendard.pretendardBold(size: 50)
        label.textColor = UIColor.pobitBlack
        
        return label
    }()
    
    private lazy var weeklyCollectionViewFlowLayout : UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        
        return layout
    }()
    
    private lazy var weeklyCollectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: weeklyCollectionViewFlowLayout)
        collectionView.register(WeeklyCollectionViewCell.self, forCellWithReuseIdentifier: WeeklyCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubViews()
        setAutoLayout()
        weeklyCollectionView.dataSource = self
        setWeeklyCollectionViewDelegate()
        setWeeklyCollectionViewDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:\(coder)) has not been implemented")
    }
}

// MARK: - Layout Helpers

extension WeeklyCalendarView {
    private func setAddSubViews() {
        self.addSubview(scrollView)
        scrollView.addSubViews([titleLabel,todayLabel,todayDateLabel,weeklyCollectionView])
    }
    
    private func setAutoLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        todayLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        
        todayDateLabel.snp.makeConstraints { make in
            make.top.equalTo(todayLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        
        weeklyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(todayDateLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(80)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Delegate

extension WeeklyCalendarView: UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    private func setWeeklyCollectionViewDelegate(){
        weeklyCollectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65, height: 58)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

// MARK: - DataSource

extension WeeklyCalendarView: UICollectionViewDataSource {
    private func setWeeklyCollectionViewDataSource() {
        weeklyCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeeklyCollectionViewCell.identifier, for: indexPath) as? WeeklyCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.setDayLabelText(text: days[indexPath.item])
        cell.setDateLabelText(text: dates[indexPath.item])
        cell.setCellBackgroundColor(state: habbitStates[indexPath.item])
        
        return cell
    }
}

