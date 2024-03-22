//
//  PobitButton.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/27.
//

import UIKit

// MARK: - Compositions

protocol PobitButtonStyle {
    var backgroundColor: UIColor { get }
    var borderColor: UIColor { get }
}

/// 테두리 없는 버튼
struct PlainButtonStyle: PobitButtonStyle {
    var backgroundColor: UIColor
    var borderColor: UIColor = .clear
}

/// 테두리 있는 버튼
struct WithBorderButtonStyle: PobitButtonStyle {
    var backgroundColor: UIColor = .white
    var borderColor: UIColor
}

// MARK: - PobitButton

final class PobitButton: UIButton {
    
    // MARK: - Properties
    
    private var style: PobitButtonStyle? {
        didSet {
            self.backgroundColor = style?.backgroundColor
            self.layer.borderColor = style?.borderColor.cgColor
        }
    }
    
    private var buttonTitle: String = "" {
        didSet {
            self.setTitle(buttonTitle, for: .normal)
        }
    }
    
    private var buttonFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            self.titleLabel?.font = buttonFont
        }
    }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension PobitButton {
    /// 컴포지션 설정
    func setStyle(_ style: PobitButtonStyle) {
        self.style = style
    }
    
    /// 런타임에 동적으로 title 업데이트 필요할 경우
    func updateTitle(with title: String) {
        self.buttonTitle = title
    }
    /// 런타임에 동적으로 font 업데이트 필요할 경우
    func updateFont(font: UIFont?) {
        self.buttonFont = font ?? .systemFont(ofSize: 20)
    }
}

// MARK: - Factory Methods

extension PobitButton {
    static func makeSquareButton(title: String) -> PobitButton {
        let button = PobitButton(type: .system)
        let style = WithBorderButtonStyle(borderColor: .pobitStone4)
        
        button.setStyle(style)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.pobitBlack, for: .normal)
        button.titleLabel?.font = Pretendard.regular(size: 20)
        
        return button
    }
    
    static func makePlainButton(title: String, backgroundColor: UIColor) -> PobitButton {
        let button = PobitButton(type: .system)
        let style = PlainButtonStyle(backgroundColor: backgroundColor)
        
        button.style = style
        button.buttonTitle = title
        button.setTitleColor(.pobitWhite, for: .normal)
        button.titleLabel?.font = Pretendard.medium(size: 24)
        
        return button
    }
}
