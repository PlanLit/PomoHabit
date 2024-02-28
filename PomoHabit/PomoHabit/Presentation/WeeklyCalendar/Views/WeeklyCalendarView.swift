// MARK: - 진행 상태//
//  WeeklyCalendarView.swift
//  PomoHabit
//
//  Created by 원동진 on 2/27/24.
//

import UIKit

import SnapKit

// MARK: - WeeklyCalendarView

final class WeeklyCalendarView: BaseView {
    
    // MARK: - Properties
    
    let days = ["월","화","수","목","금","토","일"]
    
    let dates = ["26","27","28","29","1","2","3"] // 임시
    
    let habbitStates = [HabbitState.done,HabbitState.doNot,HabbitState.done,HabbitState.notStart,HabbitState.notStart,HabbitState.notStart,HabbitState.notStart] // 임시 데이터
    
    // MARK: - DividerView
    
    private lazy var firstDivider = DividerView()
    private lazy var secondDivider = DividerView()
    private lazy var thirdDivider = DividerView()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        return scrollView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "주간 캘린더"
        label.textColor = UIColor.pobitBlack
        label.font = Pretendard.bold(size: 26)
        
        return label
    }()
    
    // MARK: - 오늘 날짜 UI
    
    private lazy var todayLabel: BasePaddingLabel = {
        let label = BasePaddingLabel(padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        label.text = "Today"
        label.textColor = .white
        label.font = Pretendard.bold(size: 12)
        label.backgroundColor = UIColor.pobitRed2
        
        return label
    }()
    
    private lazy var todayDateLabel: UILabel = {
        let label = UILabel()
        label.text = Date().monthAndDaytoString()
        label.font = Pretendard.bold(size: 50)
        label.textColor = UIColor.pobitBlack
        
        return label
    }()
    
    // MARK: - 주간 캘린더
    
    private lazy var weeklyCollectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        
        return layout
    }()
    
    private lazy var weeklyCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: weeklyCollectionViewFlowLayout)
        collectionView.register(WeeklyCollectionViewCell.self, forCellWithReuseIdentifier: WeeklyCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    // MARK: - 진행 상태
    
    private lazy var weeklyHabbitProgressLabel = UILabel()
    
    private lazy var weeklyHabbitProgressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.layer.cornerRadius = 20
        progressView.layer.sublayers?[1].cornerRadius = 20
        progressView.progressTintColor = UIColor.pobitRed
        progressView.trackTintColor = UIColor(hex: "D9D9D9")
        
        return progressView
    }()
    
    private lazy var progressCircleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ProgressCircleImage")
        return imageView
    }()
    
    // MARK: - 습관 정보
    
    private lazy var habbitInfoLabel = UILabel()
    
    private lazy var habbitInfoView: HabbitInfoView = {
        let view = HabbitInfoView()
        view.setTitleInfoViewImage(state: HabbitState.notStart)
        return view
    }()
    
    // MARK: - 메모
    
    private lazy var noteInfoLabel = UILabel()
    
    private lazy var noteContentLabel: BasePaddingLabel = {
        let label = BasePaddingLabel(padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        label.text = "메모글 입니다."
        label.font = Pretendard.medium(size: 15)
        label.textColor = UIColor.pobitBlack
        label.numberOfLines = 0
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.layer.borderColor = UIColor.pobitStone4.cgColor
        label.layer.borderWidth = 1
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubViews()
        setAutoLayout()
        setSubTitleLabel()
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
        scrollView.addSubViews([titleLabel,todayLabel,todayDateLabel,weeklyCollectionView,firstDivider,weeklyHabbitProgressLabel,weeklyHabbitProgressView,progressCircleImageView,secondDivider,habbitInfoLabel,habbitInfoView,thirdDivider,noteInfoLabel,noteContentLabel])
    }
    
    private func setAutoLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.trailing.left.equalToSuperview()
        }
        
        // MARK: - 오늘 날짜 UI
        
        todayLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        
        todayDateLabel.snp.makeConstraints { make in
            make.top.equalTo(todayLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        
        // MARK: - 주간 캘린더
        
        weeklyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(todayDateLabel.snp.bottom).offset(12)
            make.leading.trailing.width.equalToSuperview()
            make.height.equalTo(80)
        }
        
        firstDivider.snp.makeConstraints { make in
            make.top.equalTo(weeklyCollectionView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
        }
        
        // MARK: - 진행 상태
        
        weeklyHabbitProgressLabel.snp.makeConstraints { make in
            make.top.equalTo(firstDivider.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
        }
        
        weeklyHabbitProgressView.snp.makeConstraints { make in
            make.top.equalTo(weeklyHabbitProgressLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(10)
        }
        
        progressCircleImageView.snp.makeConstraints { make in
            make.top.equalTo(weeklyHabbitProgressLabel.snp.bottom).offset(9)
            make.leading.equalToSuperview()
        }
        
        secondDivider.snp.makeConstraints { make in
            make.top.equalTo(weeklyHabbitProgressView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
        }
        
        // MARK: - 습관 정보
        
        habbitInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(secondDivider.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
        }
        
        habbitInfoView.snp.makeConstraints { make in
            make.top.equalTo(habbitInfoLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
        }
        thirdDivider.snp.makeConstraints { make in
            make.top.equalTo(habbitInfoView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
        }
        
        // MARK: - 메모
        
        noteInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(thirdDivider.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
        }
        
        noteContentLabel.snp.makeConstraints { make in
            make.top.equalTo(noteInfoLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setSubTitleLabel() {
        weeklyHabbitProgressLabel.setSubTitleLabel(text: "진행 상태")
        habbitInfoLabel.setSubTitleLabel(text: "습관 정보")
        noteInfoLabel.setSubTitleLabel(text: "메모")
    }
}

// MARK: - Methods

extension WeeklyCalendarView {
    func setWeeklyHabbitProgressView(progress : Float) {
        weeklyHabbitProgressView.progress = progress
    }
    
    func setProgressCircleImg(offset : Int) {
        progressCircleImageView.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(offset)
        }
    }
    
    
}

// MARK: - Delegate

extension WeeklyCalendarView: UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    private func setWeeklyCollectionViewDelegate(){
        weeklyCollectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65, height: 80)
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

