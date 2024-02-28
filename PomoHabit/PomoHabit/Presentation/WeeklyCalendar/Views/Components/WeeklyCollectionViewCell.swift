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
        stackView.layer.cornerRadius = 10
        stackView.layer.masksToBounds = true
        return stackView
    }()
    
    private lazy var dayLabel = UILabel()
    
    private lazy var dateLabel = UILabel()
    
    private lazy var circleImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "CircleImage")
        imageView.isHidden = true
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubViews()
        setAutoLayout()
        setLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:\(coder) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                circleImageView.isHidden = false
            }else{
                circleImageView.isHidden = true
            }
        }
    }
}

// MARK: - Layout Helpers

extension WeeklyCollectionViewCell {
    private func setAddSubViews() {
        contentView.addSubViews([upperStackView,circleImageView])
        upperStackView.addArrangedSubviews([dayLabel,dateLabel])
    }
    
    private func setAutoLayout() {
        upperStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        circleImageView.snp.makeConstraints { make in
            make.top.equalTo(upperStackView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setLabel() {
        [dayLabel,dateLabel].forEach { label in
            label.font = Pretendard.semiBold(size: 15)
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
        upperStackView.backgroundColor = state.backgroundColor
        
        if state == HabbitState.notStart{
            [dayLabel,dateLabel].forEach { label in
                label.textColor = UIColor.pobitBlack
            }
            
            upperStackView.layer.borderWidth = 1
            upperStackView.layer.borderColor = UIColor.pobitStone4.cgColor
        }else {
            [dayLabel,dateLabel].forEach { label in
                label.textColor = UIColor.white
            }
        }
    }
    
    func selectedCell() {
        circleImageView.isHidden = false
    }
}
