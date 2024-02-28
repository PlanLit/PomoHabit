//
//  CAShapeLayer+Extension.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/28.
//

import UIKit

extension CAShapeLayer {
    // 시작점과 종료점이 설정된 원
    static func primeCirclePath(in rect: CGRect) -> CGPath {
        return UIBezierPath(arcCenter: CGPoint(x: rect.size.width / 2,
                                               y: rect.size.height / 2),
                            radius: rect.size.width * 0.4, startAngle: -.pi / 2,
                            endAngle: 3 * .pi / 2, clockwise: true).cgPath
    }
    
    static func subCirclePath(in rect: CGRect) -> CGPath {
        return UIBezierPath(arcCenter: CGPoint(x: rect.width / 2.0,
                                               y: rect.height / 2.0),
                            radius: rect.size.width * 0.28,
                            startAngle: 0.0,
                            endAngle: .pi * 2.0,
                            clockwise: true).cgPath
    }
}
