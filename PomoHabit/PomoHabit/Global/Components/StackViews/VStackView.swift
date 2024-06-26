//
//  VStackView.swift
//  PomoHabit
//
//  Created by JiHoon K on 2/26/24.
//

import UIKit

// MARK: - VStackView

final class VStackView: UIStackView {
    init(spacing: CGFloat = 10, alignment: UIStackView.Alignment = .center, distribution: UIStackView.Distribution = .equalSpacing,_ views: [UIView]) {
        super.init(frame: .zero)
        self.axis = .vertical
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        
        for v in views {
            addArrangedSubview(v)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
