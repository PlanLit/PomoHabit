//
//  CircleProgressBar.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/03/05.
//

import Combine
import UIKit

import SnapKit

// MARK: - CircleProgressBar

final class CircleProgressBar: BaseView {
    
    private var timerStateSubscription: AnyCancellable?
    
    // MARK: - UI Properties
    
    private lazy var progressLayer = makeLayer(strokeColor: .pobitRed, strokeEnd: 0)
    private lazy var trackLayer = makeLayer(strokeColor: .pobitSkin, strokeEnd: 1)
    private lazy var dashedCircleLayer = makeDashedCircleLayer()
    
    private var todayLabel = UILabel().setPrimaryColorLabel(text: "오늘")
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .pobitBlack
        label.font = Pretendard.bold(size: constraintByNotch(44, 32))
        label.text = "05:00"
        
        return label
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
        
        configureCircularPath()
    }
}

// MARK: - Layout Methods

extension CircleProgressBar {
    private func setAddSubViews() {
        addSubViews([todayLabel, timeLabel])
    }
    
    private func setAutoLayout() {
        todayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(constraintByNotch(96, 84))
            make.centerX.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(todayLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }
    }
    
    private func configureCircularPath() {
        self.layer.cornerRadius = self.frame.size.width / 2
        
        trackLayer.path = CAShapeLayer.primeCirclePath(in: frame)
        progressLayer.path = CAShapeLayer.primeCirclePath(in: frame)
        
        [ trackLayer, progressLayer, dashedCircleLayer ].forEach { layer.addSublayer($0) }
    }
}

// MARK: - Action Helpers

extension CircleProgressBar {
    func updateProgressBarUI(with state: TimerState) {
        switch state {
        case .stopped:
            // TODO: 비활성화시 옅은 색상
            break
        case .running:
            break
        case .finished:
            progressLayer.strokeEnd = 1
        case .done:
            break
        }
    }
    
    func setProgressWithAnimation(duration: TimeInterval) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = duration
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        progressLayer.add(animation, forKey: "progressAnimation")
    }
    
    func resetProgressAnimation() {
        progressLayer.removeAnimation(forKey: "progressAnimation")
    }
    
    func updateTimeLabel(_ remainingTime: TimeInterval) {
        let minutes = Int(remainingTime) / 60
        let seconds = Int(remainingTime) % 60
        let timeString = String(format: "%02d:%02d", minutes, seconds)
        timeLabel.text = timeString
        DispatchQueue.main.async {
            self.timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
        }
    }
}

// MARK: - Factory Method

extension CircleProgressBar {
    private func makeLayer(strokeColor: UIColor, strokeEnd: CGFloat) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.strokeColor = strokeColor.cgColor
        layer.strokeEnd = strokeEnd
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = constraintByNotch(40, 36)
        layer.lineCap = .round
        
        return layer
    }
    
    private func makeDashedCircleLayer() -> CAShapeLayer {
        let circlePath = CAShapeLayer.subCirclePath(in: frame)
        
        let layer = CAShapeLayer()
        layer.path = circlePath
        layer.strokeColor = UIColor.pobitStone4.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 1
        layer.lineDashPattern = [5, 3] // [실선 길이, 공백 길이]
        
        return layer
    }
}

