//
//  DayButtonsTableViewCell.swift
//  myUIKitPractice
//
//  Created by JiHoon K on 2/27/24.
//

import UIKit

// MARK: - DayButtonsTableViewCell

final class DayButtonsTableViewCell: UITableViewCell {
    private var container: VStackView?
    
    /// 7개 필수 (월화수목...)
    var buttonSelectionStates: [Bool]?
    
    /// 버튼 누르면 인덱스와 누르고 나서 바뀐 버튼 상태 Bool 값 반환
    var action: ((Int, Bool) -> Void)?

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        setUpSelf()
        setAddSubviews()
        setAutoLayout()
    }
}

// MARK: - Layout Helpers

extension DayButtonsTableViewCell {
    private func setUpSelf() {
        self.selectionStyle = .none
    }
    
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
            make.edges.equalToSuperview()
        }
    }
}
