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
}
