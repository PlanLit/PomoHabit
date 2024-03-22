//
//  HabitIndicatorView.swift
//  PomoHabit
//
//  Created by JiHoon K on 3/14/24.
//

import UIKit

// MARK: - HabitIndicatorView

final class HabitIndicatorView: UIView {
    
    // MARK: - Properties
    
    private lazy var container: HStackView = makeContainer()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubviews()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Leyout Helpers

extension HabitIndicatorView {
    private func setAddSubviews() {
        addSubview(
            container
        )
    }
    
    private func setAutoLayout() {
        container.snp.makeConstraints { make in
            make.top.right.bottom.left.equalToSuperview()
        }
    }
}

// MARK: - Fectory Methods

extension HabitIndicatorView {
    private func makeContainer() -> HStackView {
        HStackView([
            HStackView(spacing: 5, [
                HStackView(spacing: 5, [
                    makeCircle(.pobitRed),
                    makeCircle(.pobitGreen),
                ]),
                makeLabel("완료"),
            ]),
            HStackView(spacing: 5, [
                makeCircle(.pobitStone2),
                makeLabel("미완료"),
            ]),
            HStackView(spacing: 5, [
                makeCircle(.pobitRed.withAlphaComponent(0.1)),
                makeLabel("시작 전"),
            ]),
        ])
    }
    
    private func makeCircle(_ color: UIColor) -> UIView {
        let circle = UIView()
        circle.backgroundColor = color
        circle.layer.cornerRadius = 6
        circle.clipsToBounds = true
        circle.snp.makeConstraints { make in
            make.width.height.equalTo(12)
        }
        
        return circle
    }
    
    private func makeLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = Pretendard.semiBold(size: 16)
        
        return label
    }
}
