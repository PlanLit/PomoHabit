//
//  UILabel+Extension.swift
//  PomoHabit
//
//  Created by 원동진 on 2/28/24.
//

import UIKit

extension UILabel {
    func setSubTitleLabel(text: String) {
        self.textColor = UIColor.pobitStone5
        self.font = Pretendard.bold(size: 24)
        self.text = text
    }
    
    func setPrimaryColorLabel(text: String) -> BasePaddingLabel {
        let label = BasePaddingLabel(padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        label.text = "Today"
        label.textColor = .white
        label.font = Pretendard.bold(size: 12)
        label.backgroundColor = UIColor.pobitRed2
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        
        return label
    }
}
