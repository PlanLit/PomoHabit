//
//  HStackView.swift
//  PomoHabit
//
//  Created by JiHoon K on 2/26/24.
//

import UIKit

// MARK: - HStackView

class HStackView: UIStackView {
    init(spacing: CGFloat = 10, alignment: UIStackView.Alignment = .center, distribution: UIStackView.Distribution = .equalSpacing,_ views: [UIView]) {
        super.init(frame: .zero)
        self.axis = .horizontal
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
        self.translatesAutoresizingMaskIntoConstraints = false
        
        for v in views {
            addArrangedSubview(v)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
