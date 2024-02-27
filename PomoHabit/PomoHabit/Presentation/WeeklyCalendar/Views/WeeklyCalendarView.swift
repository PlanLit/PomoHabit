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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubViews()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:\(coder)) has not been implemented")
    }
}

// MARK: - Layout Helpers

extension WeeklyCalendarView {
    private func setAddSubViews() {
        self.addSubview(scrollView)
        scrollView.addSubViews([titleLabel,todayLabel,todayDateLabel])
    }
    
    private func setAutoLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        todayLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        todayDateLabel.snp.makeConstraints { make in
            make.top.equalTo(todayLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
    }
}

//// MARK: - Delegate
//
//extension WeeklyCalendarView: <#Delegate#> {
//
//}
//
//// MARK: - DataSource
//
//extension WeeklyCalendarView: <#DataSource#> {
//
//}

