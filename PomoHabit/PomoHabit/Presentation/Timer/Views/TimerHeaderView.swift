//
//  TimerHeaderView.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/04/04.
//

import Combine
import UIKit

import SnapKit

final class TimerHeaderView: BaseView {
    
    // MARK: - Subjects
    
    private (set) var memoButtonTapped = PassthroughSubject<Void, Never>()
    private (set) var whiteNoiseButtonTapped = PassthroughSubject<Void, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private lazy var goalDaysCountLabel = makeGoalDaysCountLabel(text: "주5일", backgroundColor: .pobitStone0)
    private lazy var startTimeLabel = makeBlackBodyLabel(text: "09:40AM", fontSize: 16)
    private lazy var habitLabel = makeHabitLabel()
    private lazy var memoButton = makeIconButton(with: "📝")
    private lazy var dividerView = makeDividerView(height: 1)
    private lazy var whiteNoiseInfoLabel = makeBlackBodyLabel(text: "초깃값", fontSize: 16)
    private lazy var whiteNoiseButton = makeIconButton(with: "🎧")
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setUI()
        setupTimerHeaderView()
        subscribeButtonEvents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setups

extension TimerHeaderView {
    private func setUI() {
        layer.borderColor = UIColor.pobitStone3.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
    }
    
    private func subscribeButtonEvents() {
        memoButton.tapPublisher.sink { [weak self] in
            self?.memoButtonTapped.send()
        }
        .store(in: &cancellables)
        
        whiteNoiseButton.tapPublisher.sink { [weak self] in
            self?.whiteNoiseButtonTapped.send()
        }
        .store(in: &cancellables)
    }
}

// MARK: - Layout Helpers

extension TimerHeaderView {
    private func setupTimerHeaderView() {
        addSubViews(
            [goalDaysCountLabel,
             startTimeLabel,
             habitLabel,
             memoButton,
             dividerView,
             whiteNoiseInfoLabel,
             whiteNoiseButton
            ])
        
        goalDaysCountLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(LayoutLiterals.minimumVerticalSpacing)
        }
        
        startTimeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(goalDaysCountLabel)
            make.trailing.equalToSuperview().inset(LayoutLiterals.minimumHorizontalSpacing)
        }
        
        habitLabel.snp.makeConstraints { make in
            make.top.equalTo(goalDaysCountLabel.snp.bottom).offset(8)
            make.leading.equalTo(goalDaysCountLabel)
        }
        
        habitLabel.setContentHuggingPriority(.init(249), for: .horizontal)
        
        memoButton.snp.makeConstraints { make in
            make.centerY.equalTo(habitLabel)
            make.trailing.equalTo(startTimeLabel)
            make.size.equalTo(28)
            make.leading.equalTo(habitLabel.snp.trailing).offset(12)
        }
        
        memoButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        dividerView.snp.makeConstraints { make in
            make.top.equalTo(habitLabel.snp.bottom).offset(8)
            make.leading.equalTo(goalDaysCountLabel)
            make.trailing.equalTo(startTimeLabel)
        }
        
        whiteNoiseInfoLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(LayoutLiterals.minimumVerticalSpacing)
        }
        
        whiteNoiseButton.snp.makeConstraints { make in
            make.centerY.equalTo(whiteNoiseInfoLabel)
            make.trailing.equalTo(startTimeLabel)
            make.size.equalTo(28)
        }
    }
}

// MARK: - Action Helpers

extension TimerHeaderView {
    func updateViewWithUserData(_ userData: UserData) {
        let targetDatesArray = userData.targetDate.split(separator: ",").map(String.init)
        
        habitLabel.text = userData.targetHabit
        startTimeLabel.text = "\(userData.alarmTime)"
        goalDaysCountLabel.text = "주\(targetDatesArray.count)일"
        whiteNoiseInfoLabel.text = userData.whiteNoiseType
    }
}

// MARK: - FactoryMethods

extension TimerHeaderView {
    private func makeHabitLabel() -> UILabel {
        let label = UILabel()
        label.text = "독서하기"
        label.font = Pretendard.medium(size: 36)
        
        return label
    }
    
    // TODO: 중간 발표 전 Extension에 있는 메서드 이걸로 바꿉시다
    private func makeGoalDaysCountLabel(text: String, backgroundColor: UIColor) -> BasePaddingLabel {
        let label = BasePaddingLabel(padding: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8))
        label.text = text
        label.textColor = .white
        label.font = Pretendard.bold(size: 12)
        label.backgroundColor = backgroundColor
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        
        return label
    }
    
    private func makeBlackBodyLabel(text: String, fontSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = Pretendard.regular(size: fontSize)
        label.textColor = .pobitBlack
        
        return label
    }
    
    private func makeIconButton(with icon: String) -> UIButton {
        let button = UIButton()
        button.setTitle(icon, for: .normal)
        button.layer.borderColor = UIColor.pobitStone4.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        
        return button
    }
}

