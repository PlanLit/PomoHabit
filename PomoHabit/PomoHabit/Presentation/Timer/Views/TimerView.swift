//
//  TimerView.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/27.
//

import UIKit

import SnapKit

// MARK: - TimerView

final class TimerView: BaseView {
    
    // MARK: - UI Properties
    
//    private let navigationBar: PobitNavigationBarView
    
    private lazy var container: HStackView = {
        return HStackView(spacing: 16, [
            whiteNoiseButton,
            memoButton
        ])
    }()
    
    private lazy var whiteNoiseButton = PobitButton.makeSquareButton(title: "🎶")
    private lazy var memoButton = PobitButton.makeSquareButton(title: "메모")
    
    private let habitLabel: UILabel = {
        let label = UILabel()
        label.text = "블라블라블라"
        label.font = Pretendard.medium(size: 36)
        return label
    }()
    
    private let circleProgressBar = CircleProgressBar()
    
    private lazy var timerButton: PobitButton = {
        let button = PobitButton()
        let style = PlainButtonStyle(backgroundColor: .pobitStone1)
        
        button.setStyle(style)
        button.setTitle("시작", for: .normal)
        button.titleLabel?.font = Pretendard.bold(size: 20)
        
        return button
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubViews()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        circleProgressBar.setProgressWithAnimation(duration: 1.0, value: 0.7)
    }
}

// MARK: - LayoutHelpers

extension TimerView {
    private func setAddSubViews() {
        addSubViews([container, habitLabel, circleProgressBar, timerButton])
    }
    
    private func setAutoLayout() {
        container.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        whiteNoiseButton.snp.makeConstraints { make in
            make.size.equalTo(58)
        }
        
        memoButton.snp.makeConstraints { make in
            make.size.equalTo(58)
        }
        
        habitLabel.snp.makeConstraints { make in
            make.top.equalTo(container.snp.bottom).offset(42)
            make.centerX.equalToSuperview()
        }
        
        circleProgressBar.snp.makeConstraints { make in
            make.top.equalTo(habitLabel.snp.bottom).offset(48)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(66)
            make.height.equalTo(self.snp.width)
        }
        
        timerButton.snp.makeConstraints { make in
            make.top.equalTo(circleProgressBar.snp.bottom).offset(60)
            make.centerX.equalToSuperview()
            make.width.equalTo(134)
            make.height.equalTo(58)
        }
    }
}

