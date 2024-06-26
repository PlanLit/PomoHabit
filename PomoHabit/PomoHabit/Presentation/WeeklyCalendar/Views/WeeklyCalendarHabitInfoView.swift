//
//  HabitInfoVIew.swift
//  PomoHabit
//
//  Created by 원동진 on 2/27/24.
//

import UIKit

// MARK: - HabitInfoView

final class WeeklyCalendarHabitInfoView: UIView {
    
    // MARK: - Properties
    
    private lazy var titleInfoView = ImageViewAndLabelView()
    
    private lazy var timeInfoView: ImageViewAndLabelView = {
        let stackView = ImageViewAndLabelView()
        stackView.setUIImageViewImage(image: UIImage(named: "TimeImage"))
        
        return stackView
    }()
    
    private lazy var targetInfoView: ImageViewAndLabelView = {
        let stackView = ImageViewAndLabelView()
        stackView.setUIImageViewImage(image: UIImage(named: "TargetImage"))
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubViews()
        setAutoLayout()
        setUpView()
        defaultValueSetHabitInfoView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout Helpers

extension WeeklyCalendarHabitInfoView {
    private func setAddSubViews() {
        self.addSubViews([titleInfoView,timeInfoView,targetInfoView])
        
    }
    
    private func setAutoLayout() {
        titleInfoView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(LayoutLiterals.upperSecondarySpacing)
            make.leading.trailing.equalToSuperview().inset(LayoutLiterals.upperSecondarySpacing)
        }
        
        timeInfoView.snp.makeConstraints { make in
            make.top.equalTo(titleInfoView.snp.bottom).offset(LayoutLiterals.upperSecondarySpacing)
            make.leading.equalToSuperview().offset(LayoutLiterals.upperSecondarySpacing)
            make.bottom.equalToSuperview().offset(-LayoutLiterals.upperSecondarySpacing)
        }
        
        targetInfoView.snp.makeConstraints { make in
            make.top.equalTo(titleInfoView.snp.bottom).offset(LayoutLiterals.upperSecondarySpacing)
            make.trailing.equalToSuperview().offset(-LayoutLiterals.upperSecondarySpacing)
            make.bottom.equalToSuperview().offset(-LayoutLiterals.upperSecondarySpacing)
        }
    }
    
    private func setUpView() {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.pobitStone4.cgColor
    }
    
    private func defaultValueSetHabitInfoView() {
        titleInfoView.setUIImageViewImage(image: UIImage(named: "NotStartImage"))
        titleInfoView.setUplabel(text: "설정한 습관", font: Pretendard.bold(size: 20))
        timeInfoView.setUplabel(text: "00:00 ~ 00:00", font: Pretendard.medium(size: 15))
        targetInfoView.setUplabel(text: "목표시간 : 0m", font: Pretendard.medium(size: 15))
    }
}

// MARK: - Methods

extension WeeklyCalendarHabitInfoView {
    func setTitleInfoView(state: HabitState, targetHabit: String) {
        titleInfoView.setUIImageViewImage(image: state.image)
        titleInfoView.setUplabel(text: targetHabit, font: Pretendard.bold(size: 20))
    }
    
    func setTimeInfoView(duringTime : String) {
        timeInfoView.setUplabel(text: duringTime, font: Pretendard.medium(size: 15))
    }
    
    func setTargetInfoView(goalTime: Int16) {
        targetInfoView.setUplabel(text: "목표시간 : \(goalTime)m", font: Pretendard.medium(size: 15))
    }
    
}
