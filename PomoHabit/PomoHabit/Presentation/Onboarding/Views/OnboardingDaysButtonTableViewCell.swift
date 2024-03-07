//
//  DaysCollectionViewCell.swift
//  PomoHabit
//
//  Created by 최유리 on 2/29/24.
//

import UIKit

// MARK: - DaysTableViewCell

final class OnboardingDaysButtonTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private lazy var buttonContainer: VStackView = makeContainer()
    
    var buttonSelectionStates: [Bool]?
    
    var action: ((Int, Bool) -> Void)?

    // MARK: - Life Cycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setSelf()
        
        setAddSubviews()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout Helpers

extension OnboardingDaysButtonTableViewCell {
    private func setSelf() {
        self.backgroundColor = .clear
    }
    
    private func setAddSubviews() {
        contentView.addSubview(buttonContainer)
    }
    
    private func setAutoLayout() {
        buttonContainer.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-LayoutLiterals.minimumHorizontalSpacing)
            make.centerY.equalToSuperview()
        }
    }
}

// MARK: - Factory methods

extension OnboardingDaysButtonTableViewCell {
    private func makeContainer() -> VStackView {
        return VStackView(spacing: 5, alignment: .leading, [
            HStackView(spacing: 5, [
                makeDayButtonView(dayType: .mon, isSelected: buttonSelectionStates?[0] ?? false, action: { state in
                    self.action?(0, state)
                }),
                makeDayButtonView(dayType: .tue, isSelected: buttonSelectionStates?[1] ?? false, action: { state in
                    self.action?(1, state)
                }),
                makeDayButtonView(dayType: .wed, isSelected: buttonSelectionStates?[2] ?? false, action: { state in
                    self.action?(2, state)
                }),
                makeDayButtonView(dayType: .thu, isSelected: buttonSelectionStates?[3] ?? false, action: { state in
                    self.action?(3, state)
                }),
                makeDayButtonView(dayType: .fri, isSelected: buttonSelectionStates?[4] ?? false, action: { state in
                    self.action?(4, state)
                }),
            ]),
            HStackView(spacing: 5, [
                makeDayButtonView(dayType: .sat, isSelected: buttonSelectionStates?[5] ?? false, action: { state in
                    self.action?(5, state)
                }),
                makeDayButtonView(dayType: .sun, isSelected: buttonSelectionStates?[6] ?? false, action: { state in
                    self.action?(6, state)
                }),
            ])
        ])
    }
    
    private func makeDayButtonView(dayType: DayButton.Day, isSelected: Bool = false, action: @escaping ((Bool) -> Void)) -> DayButton {
        let dayButton = DayButton(dayType: dayType, isSelected: isSelected) { state in
            self.action?(0, state)
        }
        
        dayButton.snp.makeConstraints { make in
            make.width.equalTo(49)
            make.height.equalTo(49)
        }
        
        return dayButton
    }
}
