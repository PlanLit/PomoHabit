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
}
