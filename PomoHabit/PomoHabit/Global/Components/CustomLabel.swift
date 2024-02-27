//
//  CustomLabel.swift
//  PomoHabit
//
//  Created by 洪立妍 on 2/27/24.
//

import Foundation
import UIKit

import SnapKit

// MARK: - CustomLabel

class CustomLabel: UILabel {
    
    var edgeInset: UIEdgeInsets = .zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        text = "Today"
        setupLabel()
    }
    
    init(_ text: String) {
        super.init(frame: .zero)
        self.text = text
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: edgeInset.top, left: edgeInset.left, bottom: edgeInset.bottom, right: edgeInset.right)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + edgeInset.left + edgeInset.right, height: size.height + edgeInset.top + edgeInset.bottom)
    }
}

// MARK: - Private Methods

extension CustomLabel {
    
    private func setupLabel() {
        backgroundColor = UIColor.systemPink
        layer.cornerRadius = 4
        clipsToBounds = true
        textColor = .white
        font = UIFont.systemFont(ofSize: 12, weight: .bold)
    }
}

