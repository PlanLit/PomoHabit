//
//  WeeklyCollectionViewCell.swift
//  PomoHabit
//
//  Created by 원동진 on 2/27/24.
//

import UIKit

// MARK: - WeeklyCollectionViewCell

final class WeeklyCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "WeeklyCollectionViewCellid"
    
    private lazy var labelsContainer: VStackView = {
        let stackView = VStackView(spacing: 5,alignment: .fill,distribution: .fillEqually, [dayLabel,dateLabel])
        stackView.layer.cornerRadius = 10
        stackView.layer.masksToBounds = true
        return stackView
    }()
    
    private lazy var dayLabel = UILabel()
    
    private lazy var dateLabel = UILabel()
    
    private lazy var circleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "CircleImage")
        imageView.isHidden = true
        
        return imageView
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                circleImageView.isHidden = false
            } else {
                circleImageView.isHidden = true
            }
        }
    }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubViews()
        setAutoLayout()
        setLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:\(coder) has not been implemented")
    }
}

// MARK: - Layout Helpers

extension WeeklyCollectionViewCell {
    private func setAddSubViews() {
        contentView.addSubViews([labelsContainer,circleImageView])
    }
    
    private func setAutoLayout() {
        labelsContainer.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        circleImageView.snp.makeConstraints { make in
            make.top.equalTo(labelsContainer.snp.bottom).offset(5)
            make.centerX.bottom.equalToSuperview()
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
    func setDayLabelText(text: String) {
        dayLabel.text = text
    }
    
    func setDateLabelText(text: Date) {
        dateLabel.text = text.dateToString(format: "dd")
    }
    
    func setCellBackgroundColor(state: HabitState) { //습관 정보에 따라 달라지는 cell배경및 border 함수
        labelsContainer.backgroundColor = state.backgroundColor
        
        if state == HabitState.notStart{
            [dayLabel,dateLabel].forEach { label in
                label.textColor = .pobitBlack
            }
            
            labelsContainer.layer.borderWidth = 1
            labelsContainer.layer.borderColor = UIColor.pobitStone4.cgColor
        } else {
            [dayLabel,dateLabel].forEach { label in
                label.textColor = .white
            }
        }
    }
}
