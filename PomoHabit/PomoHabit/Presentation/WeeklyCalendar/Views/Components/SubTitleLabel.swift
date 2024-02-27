//
//  SubTitleLabel.swift
//  PomoHabit
//
//  Created by 원동진 on 2/27/24.
//

import UIKit

import SnapKit

// MARK: - SubTitleLabel

class SubTitleLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Layout Helpers

extension SubTitleLabel {
    private func setUpSubTitleLabel() {
        self.textColor = UIColor.pobitStone5
        self.font = Pretendard.pretendardBold(size: 24)
    }
}

// MARK: - Methods

extension SubTitleLabel {
    func setSubTitleLabelText(text : String) {
        self.text = text
    }
}
