//
//  TimerView.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/27.
//

import Combine
import UIKit

import SnapKit

// MARK: - TimerView

final class TimerView: BaseView {
    
    // MARK: - Properties
    
    private (set) var memoButtonTapped = PassthroughSubject<Void, Never>()
    private (set) var whiteNoiseButtonTapped = PassthroughSubject<Void, Never>()
    private (set) var timerButtonTapped = PassthroughSubject<Void, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private let navigationBar = PobitNavigationBarView(title: "타이머", viewType: .plain)
    
    private lazy var timerHeaderView = makeTimerHeaderView()
    private lazy var goalDaysCountLabel = makeGoalDaysCountLabel(text: "주5일", backgroundColor: .pobitStone0)
    private lazy var startTimeLabel = makeBlackBodyLabel(text: "09:40AM", fontSize: 16)
    private lazy var habitLabel = makeHabitLabel()
    private lazy var memoButton = makeMemoButton()
    private lazy var dividerView = makeDividerView(height: 1)
    private lazy var whiteNoiseInfoLabel = makeBlackBodyLabel(text: "🎧 배경음을 선택해보세요!", fontSize: 16)
    private lazy var whiteNoiseButton = makeWhiteNoiseEditButton()
    
    private lazy var starView = UIImageView(image: UIImage(named: "Star"))
    private (set) var circleProgressBar = CircleProgressBar()
    
    private lazy var timerButton: PobitButton = {
        let style = PlainButtonStyle(backgroundColor: .pobitStone1)
        
        let button = PobitButton()
        button.setStyle(style)
        button.titleLabel?.font = Pretendard.bold(size: 20)
        
        return button
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubViews()
        setAutoLayout()
        subscribeButtonEvents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Subscriptions

extension TimerView {
    private func subscribeButtonEvents() {
        memoButton.tapPublisher.sink { [weak self] in
            self?.memoButtonAction()
        }
        .store(in: &cancellables)
        
        whiteNoiseButton.tapPublisher.sink { [weak self] in
            self?.whiteNoiseButtonAction()
        }
        .store(in: &cancellables)
        
        timerButton.tapPublisher.sink { [weak self] in
            self?.timerButtonAction()
        }
        .store(in: &cancellables)
    }
    
    private func memoButtonAction() {
        memoButtonTapped.send()
    }
    
    private func whiteNoiseButtonAction() {
        whiteNoiseButtonTapped.send()
    }
    
    private func timerButtonAction() {
        timerButtonTapped.send()
    }
}

// MARK: - Layout Helpers

extension TimerView {
    private func setAddSubViews() {
        addSubViews([navigationBar, timerHeaderView, starView, circleProgressBar, timerButton])
    }
    
    private func setAutoLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(58)
        }
        
        timerHeaderView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview().inset(LayoutLiterals.minimumHorizontalSpacing)
            make.height.equalTo(152)
        }
        
        setupTimerHeaderView()
        
        starView.snp.makeConstraints { make in
            make.top.equalTo(timerHeaderView.snp.bottom).offset(48)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(72)
        }
        
        circleProgressBar.snp.makeConstraints { make in
            make.top.equalTo(timerHeaderView.snp.bottom).offset(80)
            make.centerX.equalToSuperview()
            make.size.equalTo(280)
        }
        
        timerButton.snp.makeConstraints { make in
            make.top.equalTo(circleProgressBar.snp.bottom).offset(42)
            make.centerX.equalToSuperview()
            make.width.equalTo(134)
            make.height.equalTo(58)
        }
    }
}

// MARK: - Action Helpers

extension TimerView {
    func updateTimerButtonState(_ state: TimerState) {
        switch state {
        case .stopped:
            timerButton.setTitle("시작", for: .normal)
            timerButton.backgroundColor = .pobitBlack
            timerButton.isEnabled = true
        case .running:
            timerButton.setTitle("완료", for: .normal)
            timerButton.backgroundColor = .pobitStone1
            timerButton.isEnabled = false
        case .finished:
            timerButton.setTitle("완료", for: .normal)
            timerButton.backgroundColor = .pobitBlack
            timerButton.isEnabled = true
        }
    }
    
    func updateViewWithUserData(_ userData: UserData) {
        habitLabel.text = userData.targetHabit
        startTimeLabel.text = userData.startTime
        goalDaysCountLabel.text = "주\(userData.targetDate.count)일"
    }
}

// MARK: - TimerHeaderView

extension TimerView {
    private func setupTimerHeaderView() {
        timerHeaderView.addSubViews(
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
        
        memoButton.snp.makeConstraints { make in
            make.centerY.equalTo(habitLabel)
            make.trailing.equalTo(startTimeLabel)
            make.size.equalTo(24)
        }
        
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
            make.size.equalTo(20)
        }
    }
    
    private func makeTimerHeaderView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.pobitStone4.cgColor
        view.layer.borderWidth = 1
        view.backgroundColor = .clear
        
        return view
    }
    
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
    
    private func makeMemoButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .gray
        
        return button
    }
    
    private func makeWhiteNoiseEditButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = .gray
        
        return button
    }
}
