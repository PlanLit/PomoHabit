//
//  CircleGaugeImageView.swift
//  PomoHabit
//
//  Created by JiHoon K on 3/20/24.
//

import UIKit

// MARK: - CircleGaugeImageView

final class CircleGaugeImageView: UIView {
    
    // MARK: - Properties
    
    private var progressLayer = CAShapeLayer()
    private var trackLayer = CAShapeLayer()
    private var imageView = UIImageView()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpSelf()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Layout Helpers

extension CircleGaugeImageView {
    private func setUpSelf() {
        backgroundColor = .clear
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 1.5) / 2, startAngle: -(.pi / 2), endAngle: 2 * .pi, clockwise: true)
        
        trackLayer.path = circlePath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = UIColor.systemGray6.cgColor
        trackLayer.lineWidth = 18.0
        trackLayer.strokeEnd = 1.0
        layer.addSublayer(trackLayer)
        
        progressLayer.path = circlePath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.pobitRed2.cgColor
        progressLayer.lineWidth = 18.0
        progressLayer.strokeEnd = 0.0
        layer.addSublayer(progressLayer)
        
        addSubview(imageView)
    }
    
    func setProgress(to progressConstant: CGFloat, withAnimation: Bool) {
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = withAnimation ? 1 : 0
        circularProgressAnimation.toValue = progressConstant
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
    
    func setImage(_ image: UIImage?) {
        imageView.image = image
        imageView.frame = CGRect(x: 0, y: 0, width: frame.size.width - 18.0, height: frame.size.height - 18.0)
        imageView.layer.cornerRadius = imageView.frame.width / 2.0
        imageView.clipsToBounds = true
        imageView.center = CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0)
        imageView.contentMode = .scaleAspectFit
    }
}
