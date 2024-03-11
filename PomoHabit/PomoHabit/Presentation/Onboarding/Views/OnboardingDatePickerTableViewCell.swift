//
//  OnboardingDatePickerTableViewCell.swift
//  PomoHabit
//
//  Created by JiHoon K on 3/8/24.
//

import UIKit

// MARK: - OnboardingDatePickerTableViewCell

final class OnboardingDatePickerTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    lazy var datePicker: UIDatePicker = makeDatePicker()
    var dateChangeEnded: ((Date) -> ())?
    
    // MARK: - Life Cycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpSelf()
        
        setAddSubviews()
        setAutoLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout Helpers

extension OnboardingDatePickerTableViewCell {
    private func setUpSelf() {
        self.backgroundColor = .clear
    }
    
    private func setAddSubviews() {
        contentView.addSubview(datePicker)
    }
    
    private func setAutoLayout() {
        datePicker.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-LayoutLiterals.minimumHorizontalSpacing)
            make.centerY.equalToSuperview()
        }
    }
}

// MARK: - Factory Methods

extension OnboardingDatePickerTableViewCell {
    private func makeDatePicker() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(didEndEditingDatePickerValue), for: .editingDidEnd)
        
        return datePicker
    }
}

// MARK: - Action Helpers

extension OnboardingDatePickerTableViewCell {
    @objc private func didEndEditingDatePickerValue() {
        dateChangeEnded?(datePicker.date)
    }
}
