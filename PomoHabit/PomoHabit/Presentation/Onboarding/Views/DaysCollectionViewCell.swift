//
//  DaysCollectionViewCell.swift
//  PomoHabit
//
//  Created by 최유리 on 2/29/24.
//

import UIKit

import SnapKit

// MARK: - DaysViewCell

final class DaysCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    
    static let identifier = "DaysCollectionViewCell"
    
    private var container: VStackView?
    var buttonSelectionStates: [Bool]?
    var action: ((Int, Bool) -> Void)?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubviews()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout Helpers

extension DaysCollectionViewCell {
    private func setAddSubviews() {
        container = VStackView(spacing: 5, alignment: .leading, [
            HStackView(spacing: 5, [
                DayButton(dayType: .mon, isSelected: buttonSelectionStates?[0] ?? false) { state in
                    self.action?(0, state)
                },
                DayButton(dayType: .tue, isSelected: buttonSelectionStates?[1] ?? false) { state in
                    self.action?(1, state)
                },
                DayButton(dayType: .wed, isSelected: buttonSelectionStates?[2] ?? false) { state in
                    self.action?(2, state)
                },
                DayButton(dayType: .thu, isSelected: buttonSelectionStates?[3] ?? false) { state in
                    self.action?(3, state)
                },
                DayButton(dayType: .fri, isSelected: buttonSelectionStates?[4] ?? false) { state in
                    self.action?(4, state)
                },
            ]),
            HStackView(spacing: 5, [
                DayButton(dayType: .sat, isSelected: buttonSelectionStates?[5] ?? false) { state in
                    self.action?(5, state)
                },
                DayButton(dayType: .sun, isSelected: buttonSelectionStates?[6] ?? false) { state in
                    self.action?(6, state)
                },
            ])
        ])
        contentView.addSubview(container ?? UIView())
    }
    
    private func setAutoLayout() {
        container?.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(100)
        }
    }
}
