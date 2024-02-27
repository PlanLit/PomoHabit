//
//  WeeklyCollectionViewCell.swift
//  PomoHabit
//
//  Created by 원동진 on 2/27/24.
//

import UIKit

// MARK: - WeeklyCollectionViewCell

class WeeklyCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "WeeklyCollectionViewCellid"
    private lazy var upperStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var dayLabel = UILabel()
    
    private lazy var dateLabel = UILabel()
    
    private lazy var circleImageView : UIImageView = {
        let view = UIImageView()
        
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubViews()
        setAutoLayout()
        setWeeklyCollectionViewCell()
        setLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:\(coder) has not been implemented")
    }
}

// MARK: - Layout Helpers

extension WeeklyCollectionViewCell {
    private func setAddSubViews() {
        contentView.addSubview(upperStackView)
        upperStackView.addArrangedSubviews([dayLabel,dateLabel])
    }
    
    private func setAutoLayout() {
        upperStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setWeeklyCollectionViewCell() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    private func setLabel() {
        [dayLabel,dateLabel].forEach { label in
            label.font = Pretendard.pretendardSemiBold(size: 15)
            label.textAlignment = .center
        }
    }
}

// MARK: - Methods

extension WeeklyCollectionViewCell{
    func setDayLabelText(text : String) {
        dayLabel.text = text
    }
    
    func setDateLabelText(text : String) { // 임시
        dateLabel.text = text
    }
    
    func setCellBackgroundColor(state: HabbitState) {
        self.backgroundColor = state.backgroundColor
        
        if state == HabbitState.notStart{
            [dayLabel,dateLabel].forEach { label in
                label.textColor = UIColor.pobitBlack
            }
            
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.pobitStone4.cgColor
        }else {
            [dayLabel,dateLabel].forEach { label in
                label.textColor = UIColor.white
            }
        }
    }
}
