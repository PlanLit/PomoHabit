// MARK: - 진행 상태//
//  WeeklyCalendarView.swift
//  PomoHabit
//
//  Created by 원동진 on 2/27/24.
//

import UIKit

import SnapKit

protocol SendSelectedData{
    func sendDate(date: Date,completion: @escaping(WeeklyHabitInfoModel)-> Void)
}

// MARK: - WeeklyCalendarView

final class WeeklyCalendarView: BaseView {
    
    // MARK: - Properties
    var weeklyHabitState: [HabitState] = []
    let weeklyDays = ["월","화","수","목","금","토","일"]
    var weeklyDatesData : [Date] = []
    var dateDelegate: SendSelectedData?
    
    // MARK: - DividerView
    
    private lazy var firstDivider = UIView().makeDividerView(height: 1)
    private lazy var secondDivider = UIView().makeDividerView(height: 1)
    private lazy var thirdDivider = UIView().makeDividerView(height: 1)
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private lazy var navigationBarView = PobitNavigationBarView(title: "주간 캘린더", viewType: .plain)
    
    // MARK: - 오늘 날짜 UI
    
    private lazy var todayLabel = UILabel().setPrimaryColorLabel(text: "Today")
    
    private lazy var todayDateLabel: UILabel = {
        let label = UILabel()
        label.text = Date().dateToString()
        label.font = Pretendard.bold(size: 50)
        label.textColor = .pobitBlack
        
        return label
    }()
    
    // MARK: - 주간 캘린더
    
    private lazy var weeklyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(WeeklyCollectionViewCell.self, forCellWithReuseIdentifier: WeeklyCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    // MARK: - 진행 상태
    
    private lazy var weeklyHabitProgressLabel = UILabel()
    
    private lazy var weeklyHabitProgressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.layer.cornerRadius = 20
        progressView.layer.sublayers?[1].cornerRadius = 20
        progressView.progressTintColor = .pobitRed
        progressView.trackTintColor = UIColor(hex: "D9D9D9")
        
        return progressView
    }()
    
    private lazy var progressCircleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ProgressCircleImage")
        return imageView
    }()
    
    // MARK: - 습관 정보
    
    private lazy var habitInfoLabel = UILabel()
    
    private lazy var habitInfoView = WeeklyCalendarHabitInfoView()
    
    // MARK: - 메모
    
    private lazy var noteInfoLabel = UILabel()
    
    private lazy var noteContentLabel: BasePaddingLabel = {
        let label = BasePaddingLabel(padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        label.font = Pretendard.medium(size: 15)
        label.textColor = .pobitBlack
        label.numberOfLines = 0
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.layer.borderColor = UIColor.pobitStone4.cgColor
        label.layer.borderWidth = 1
        label.text = "주간 캘린더를 클릭하여 습관 정보를 확인하세요."
        
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
        scrollView.addSubViews([navigationBarView,todayLabel,todayDateLabel,weeklyCollectionView,firstDivider,weeklyHabitProgressLabel,weeklyHabitProgressView,progressCircleImageView,secondDivider,habitInfoLabel,habitInfoView,thirdDivider,noteInfoLabel,noteContentLabel])
    }
    
    private func setAutoLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        navigationBarView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        // MARK: - 오늘 날짜 UI
        
        todayLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBarView.snp.bottom).offset(LayoutLiterals.upperPrimarySpacing)
            make.centerX.equalToSuperview()
        }
        
        todayDateLabel.snp.makeConstraints { make in
            make.top.equalTo(todayLabel.snp.bottom).offset(LayoutLiterals.upperSecondarySpacing)
            make.centerX.equalToSuperview()
        }
        
        // MARK: - 주간 캘린더
        
        weeklyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(todayDateLabel.snp.bottom).offset(LayoutLiterals.upperSecondarySpacing)
            make.leading.trailing.width.equalToSuperview()
            make.height.equalTo(80)
        }
        
        firstDivider.snp.makeConstraints { make in
            make.top.equalTo(weeklyCollectionView.snp.bottom).offset(LayoutLiterals.upperSecondarySpacing)
            make.leading.trailing.equalToSuperview()
        }
        
        // MARK: - 진행 상태
        
        weeklyHabitProgressLabel.snp.makeConstraints { make in
            make.top.equalTo(firstDivider.snp.bottom).offset(LayoutLiterals.upperPrimarySpacing)
            make.leading.trailing.equalToSuperview()
        }
        
        weeklyHabitProgressView.snp.makeConstraints { make in
            make.top.equalTo(weeklyHabitProgressLabel.snp.bottom).offset(LayoutLiterals.upperSecondarySpacing)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(10)
        }
        
        progressCircleImageView.snp.makeConstraints { make in
            make.top.equalTo(weeklyHabitProgressLabel.snp.bottom).offset(9)
            make.leading.equalToSuperview()
        }
        
        secondDivider.snp.makeConstraints { make in
            make.top.equalTo(weeklyHabitProgressView.snp.bottom).offset(LayoutLiterals.upperPrimarySpacing)
            make.leading.trailing.equalToSuperview()
        }
        
        // MARK: - 습관 정보
        
        habitInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(secondDivider.snp.bottom).offset(LayoutLiterals.upperPrimarySpacing)
            make.leading.trailing.equalToSuperview()
        }
        
        habitInfoView.snp.makeConstraints { make in
            make.top.equalTo(habitInfoLabel.snp.bottom).offset(LayoutLiterals.upperSecondarySpacing)
            make.leading.trailing.equalToSuperview()
        }
        thirdDivider.snp.makeConstraints { make in
            make.top.equalTo(habitInfoView.snp.bottom).offset(LayoutLiterals.upperPrimarySpacing)
            make.leading.trailing.equalToSuperview()
        }
        
        // MARK: - 메모
        
        noteInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(thirdDivider.snp.bottom).offset(LayoutLiterals.upperPrimarySpacing)
            make.leading.trailing.equalToSuperview()
        }
        
        noteContentLabel.snp.makeConstraints { make in
            make.top.equalTo(noteInfoLabel.snp.bottom).offset(LayoutLiterals.upperSecondarySpacing)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setSubTitleLabel() {
        weeklyHabitProgressLabel.setSubTitleLabel(text: "주간 달성율")
        habitInfoLabel.setSubTitleLabel(text: "습관 정보")
        noteInfoLabel.setSubTitleLabel(text: "메모")
    }
}

// MARK: - Methods

extension WeeklyCalendarView {
    func setWeeklyHabitProgressView(progress: Float) {
        weeklyHabitProgressView.progress = progress
    }
    
    func setProgressCircleImg(offset: Int) {
        progressCircleImageView.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(offset)
        }
    }
    
    func setWeeklyDates(weeklyDates : [Date]) {
        weeklyDatesData = weeklyDates
    }
    
    func setWeeklyHabitState(setData: [HabitState]) {
        weeklyHabitState = setData
    }
    
    func setHabitInfoView(state: HabitState, targetHabit: String,duringTime: String,goalTime: Int16) {
        habitInfoView.setTitleInfoView(state: state, targetHabit: targetHabit)
        habitInfoView.setTimeInfoView(duringTime: duringTime)
        habitInfoView.setTargetInfoView(goalTime: goalTime)
    }
    
    func setNoteContentLabel(note: String) {
        if note == "" {
            noteContentLabel.text = "메모를 입력하지 않았습니다."
        } else {
            noteContentLabel.text = note
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dateDelegate?.sendDate(date: weeklyDatesData[indexPath.item]) { [self] weeklyHabitInfo in
            
            setHabitInfoView(state: weeklyHabitInfo.habitstate ?? .notStart, targetHabit: weeklyHabitInfo.targetHabit ?? "습관 정보", duringTime: weeklyHabitInfo.duringTime ?? "00:00 ~ 00:00", goalTime: weeklyHabitInfo.goalTime ?? 0)
            setNoteContentLabel(note: weeklyHabitInfo.note ?? "")
        }
    }
}

// MARK: - DataSource

extension WeeklyCalendarView: UICollectionViewDataSource {
    private func setWeeklyCollectionViewDataSource() {
        weeklyCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weeklyDatesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeeklyCollectionViewCell.identifier, for: indexPath) as? WeeklyCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.setDayLabelText(text: weeklyDays[indexPath.item])
        cell.setDateLabelText(text: weeklyDatesData[indexPath.item])
        cell.setCellBackgroundColor(state: weeklyHabitState[indexPath.item])
        
        return cell
    }
}

// MARK: - GetData


