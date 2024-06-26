//
//  UIView+Extension.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/26.
//

import UIKit

extension UIView {
    func addSubViews(_ views : [UIView]) {
        _ = views.map { self.addSubview($0) }
    }
    
    func makeDividerView(height : CGFloat) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.pobitStone3
        view.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
        
        return view
    }
    
    var hasNotch: Bool {
        return !( (UIScreen.main.bounds.width / UIScreen.main.bounds.height) > 0.5 )
    }
    
    /// Constraint 설정 시 노치 유무로 기기 대응
    func constraintByNotch(_ hasNotch: CGFloat, _ noNotch: CGFloat) -> CGFloat {
        return self.hasNotch ? hasNotch : noNotch
    }
}
