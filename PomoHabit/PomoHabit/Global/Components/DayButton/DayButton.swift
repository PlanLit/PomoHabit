//
//  DayButton.swift
//  myUIKitPractice
//
//  Created by JiHoon K on 2/26/24.
//

import UIKit

// MARK: - DayButton

final class DayButton: UIView {
    private var dayType: Day?
    
    /// 버튼 누르고 나서 바뀐 버튼 상태 Bool 값 반환
    private var action: ((Bool) -> Void)?
    
    private var isSelected: Bool = false {
        didSet {
            setupCustomButtonAppearance()
        }
    }
    
    private lazy var customButton: UIButton = {
        let button = UIButton(type: .system, primaryAction: .init(handler: { _ in
            self.isSelected.toggle()
            self.action?(self.isSelected)
        }))
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.systemGray5.cgColor
        
        return button
    }()
    
    init(dayType: Day, isSelected: Bool = false, action: @escaping ((Bool) -> Void)) {
        super.init(frame: .zero)
        
        self.dayType = dayType
        self.isSelected = isSelected
        self.action = action
        setupCustomButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
}

// MARK: - Layout Helpers

extension DayButton {
    private func setupCustomButton() {
        addSubview(customButton)
        customButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalTo(49)
            make.height.equalTo(49)
        }
        setupCustomButtonAppearance()
    }
    
    private func setupCustomButtonAppearance() {
        customButton.setTitle(dayType?.rawValue, for: .normal)
        customButton.backgroundColor = isSelected ? .systemGreen : .white // 색 변경 필요
        customButton.setTitleColor(isSelected ? .white : .black, for: .normal)
        customButton.layer.borderWidth = isSelected ? 0 : 1
    }
}

// MARK: - Types

extension DayButton {
    enum Day: String {
        case mon = "월"
        case tue = "화"
        case wed = "수"
        case thu = "목"
        case fri = "금"
        case sat = "토"
        case sun = "일"
    }
}
