//
//  UILabel+Extension.swift
//  PomoHabit
//
//  Created by 원동진 on 2/28/24.
//

import UIKit

extension UILabel {
    func setSubTitleLabel(text: String) {
        self.textColor = .pobitStone5
        self.font = Pretendard.bold(size: 24)
        self.text = text
    }
    
    func setPrimaryColorLabel(text: String) -> BasePaddingLabel {
        let label = BasePaddingLabel(padding: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        label.text = text
        label.textColor = .white
        label.font = Pretendard.bold(size: 12)
        label.backgroundColor = .pobitRed2
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        
        return label
    }
    
    func makeMyPageLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .pobitStone2
        label.font = Pretendard.regular(size: 12)
        
        return label
    }
}
