import UIKit

import SnapKit

final class CircleProgressBar: UIView {
    
    // MARK: - UIProperties
    
    private lazy var progressLayer = makeLayer(strokeColor: .pobitRed, strokeEnd: 0)
    private lazy var trackLayer = makeLayer(strokeColor: .pobitSkin, strokeEnd: 1.0)
    private lazy var dashedCircleLayer = makeDashedCircleLayer()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "22:01"
        label.textColor = .pobitBlack
        label.font = Pretendard.bold(size: 50)
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
        addSubViews([timeLabel])
    }
    
    private func setAutoLayout() {
        timeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func configureCircularPath() {
        self.layer.cornerRadius = self.frame.size.width / 2
        
        // 시작점과 종료점을 설정하여 원을 그림
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2,
                                                           y: frame.size.height / 2),
                                        radius: frame.size.width / 2, startAngle: -.pi / 2,
                                        endAngle: 3 * .pi / 2, clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        progressLayer.path = circularPath.cgPath
        
        [ trackLayer, progressLayer, dashedCircleLayer ].forEach { layer.addSublayer($0) }
    }
    
    func setProgressWithAnimation(duration: TimeInterval, value: Float) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = value
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        progressLayer.strokeEnd = CGFloat(value)
        progressLayer.add(animation, forKey: "animateprogress")
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
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0,
                                                         y: frame.size.height / 2.0),
                                      radius: 100,
                                      startAngle: 0.0,
                                      endAngle: .pi * 2.0,
                                      clockwise: true)
        
        let layer = CAShapeLayer()
        layer.path = circlePath.cgPath
        layer.strokeColor = UIColor.pobitStone4.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 1
        layer.lineDashPattern = [5, 3] // [실선 길이, 공백 길이]
        
        return layer
    }
}

