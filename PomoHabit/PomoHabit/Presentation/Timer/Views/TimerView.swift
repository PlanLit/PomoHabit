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
    
    // MARK: - Subjects

    private (set) var timerButtonTapped = PassthroughSubject<Void, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private let navigationBar = PobitNavigationBarView(title: "타이머", viewType: .plain)

    private (set) var timerHeaderView = TimerHeaderView()
    private let starView = UIImageView(image: UIImage(named: "Star"))
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
        timerButton.tapPublisher.sink { [weak self] in
            self?.timerButtonTapped.send()
        }
        .store(in: &cancellables)
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
        }
        
        timerHeaderView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(constraintByNotch(24, 12))
            make.leading.trailing.equalToSuperview().inset(LayoutLiterals.minimumHorizontalSpacing)
            make.height.equalTo(152)
        }
        
        starView.snp.makeConstraints { make in
            make.top.equalTo(timerHeaderView.snp.bottom).offset(constraintByNotch(36, 12))
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(72)
        }
        
        circleProgressBar.snp.makeConstraints { make in
            make.top.equalTo(timerHeaderView.snp.bottom).offset(constraintByNotch(68, 44))
            make.centerX.equalToSuperview()
            make.size.equalTo(constraintByNotch(280, 240))
        }
        
        timerButton.snp.makeConstraints { make in
            make.top.equalTo(circleProgressBar.snp.bottom).offset(constraintByNotch(24, 12))
            make.centerX.equalToSuperview()
            make.width.equalTo(134)
            make.height.equalTo(58)
        }
    }
}

// MARK: - Action Helpers

extension TimerView {
    func updateTimerButtonUI(with state: TimerState) {
        switch state {
        case .stopped:
            timerButton.setTitle("시작", for: .normal)
            timerButton.backgroundColor = .pobitBlack
        case .running:
            timerButton.setTitle("완료", for: .normal)
            timerButton.backgroundColor = .pobitStone1
        case .finished:
            timerButton.setTitle("완료", for: .normal)
            timerButton.backgroundColor = .pobitBlack
        case .done:
            break
        }
    }
}
