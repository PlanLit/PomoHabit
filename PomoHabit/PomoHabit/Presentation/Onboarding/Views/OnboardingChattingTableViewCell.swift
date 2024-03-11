//
//  OnboardingChattingCell.swift
//  PomoHabit
//
//  Created by 최유리 on 2/29/24.
//

import UIKit

// MARK: - OnboardingChattingCell

final class OnboardingChattingTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private var data: OnboardingChattingCellData?
    private lazy var chattingLabel: BasePaddingLabel = makeChattingLabel()
    
    // MARK: - Life Cycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setAddSubviews()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Layout Helpers

extension OnboardingChattingTableViewCell {
    private func setAddSubviews() {
        contentView.addSubview(chattingLabel)
    }
    
    private func setAutoLayout() {
        chattingLabel.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.centerY.equalToSuperview()
        }
    }
    
    func configureCell(with model: OnboardingChattingCellData) {
        self.backgroundColor = .clear
        self.chattingLabel.text = model.message
        self.data = model
        
        switch model.chatDirection {
        case .incoming:
            chattingLabel.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(LayoutLiterals.minimumHorizontalSpacing)
            }
        case .outgoing:
            chattingLabel.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(-LayoutLiterals.minimumHorizontalSpacing)
            }
            
            chattingLabel.backgroundColor = .pobitGreen
            chattingLabel.textColor = .pobitWhite
        }
    }
}

// MARK: - Factory Methods

extension OnboardingChattingTableViewCell {
    private func makeChattingLabel() -> BasePaddingLabel {
        let label = BasePaddingLabel(padding: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        label.font = Pretendard.medium(size: 16)
        label.backgroundColor = .pobitWhite
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.textColor = .pobitBlack
        
        return label
    }
}
