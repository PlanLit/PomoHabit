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
                makeDayButtonView(dayType: .mon, index: 0, isSelected: buttonSelectionStates?[0] ?? false),
                makeDayButtonView(dayType: .tue, index: 1, isSelected: buttonSelectionStates?[1] ?? false),
                makeDayButtonView(dayType: .wed, index: 2, isSelected: buttonSelectionStates?[2] ?? false),
                makeDayButtonView(dayType: .thu, index: 3, isSelected: buttonSelectionStates?[3] ?? false),
                makeDayButtonView(dayType: .fri, index: 4, isSelected: buttonSelectionStates?[4] ?? false),
            ]),
            HStackView(spacing: 5, [
                makeDayButtonView(dayType: .sat, index: 5, isSelected: buttonSelectionStates?[5] ?? false),
                makeDayButtonView(dayType: .sun, index: 6, isSelected: buttonSelectionStates?[6] ?? false),
            ])
        ])
    }
    
    private func makeDayButtonView(dayType: DayButton.Day, index: Int, isSelected: Bool = false) -> DayButton {
        let dayButton = DayButton(dayType: dayType, isSelected: isSelected) { state in
            self.action?(index, state)
        }
        
        dayButton.snp.makeConstraints { make in
            make.width.equalTo(49)
            make.height.equalTo(49)
        }
        
        return dayButton
    }
}
