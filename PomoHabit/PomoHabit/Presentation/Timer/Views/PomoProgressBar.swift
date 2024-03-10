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
    
    private var timer: Timer?
    private var remainingTime: TimeInterval = 5
    
    // MARK: - UI Properties
    
    private lazy var progressLayer = makeLayer(strokeColor: .pobitRed, strokeEnd: 0)
    private lazy var trackLayer = makeLayer(strokeColor: .pobitSkin, strokeEnd: 1.0)
    private lazy var dashedCircleLayer = makeDashedCircleLayer()
    
    private var todayLabel = UILabel().setPrimaryColorLabel(text: "오늘")
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .pobitBlack
        label.font = Pretendard.bold(size: 44)
        
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
            make.top.equalToSuperview().offset(96)
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
    
    func setProgressWithAnimation(duration: TimeInterval, fromValue: Float, toValue: Float) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        
        progressLayer.strokeEnd = CGFloat(toValue)
        progressLayer.add(animation, forKey: "animateprogress")
    }

}

// MARK: - Action Helpers

extension CircleProgressBar {
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer() {
        if remainingTime > 0 {
            // 새로운 원형 진행 바의 비율
            let newTimeFraction = remainingTime / 60
            // 이전 원형 진행 바의 비율
            let previousTimeFraction = (remainingTime + 1) / 60
            remainingTime -= 1
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.timeLabel.text = String(format: "%02d:%02d", Int(self.remainingTime) / 60, Int(self.remainingTime) % 60)
                self.setProgressWithAnimation(duration: 1, fromValue: Float(previousTimeFraction), toValue: Float(newTimeFraction))
            }
        } else {
            timer?.invalidate()
            timer = nil
            
            DispatchQueue.main.async { [weak self] in
                self?.progressLayer.isHidden = true
            }
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
        layer.lineWidth = 40
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

