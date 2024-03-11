//
//  PobitNavigationBarView.swift
//  PomoHabit
//
//  Created by 최유리 on 2/27/24.
//

import UIKit

import SnapKit

enum navigationViewType {
    case plain
    case withDismissButton
}

// MARK: - PobitNavigationBarView

final class PobitNavigationBarView: UIView {
    
    // MARK: - Properties
    
    private var viewType: navigationViewType
    
    // MARK: - UI Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Pretendard.bold(size: 25)
        
        return label
    }()
    
    private lazy var dividerView = makeDividerView(height: 1)
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        return button
    }()
    
    // MARK: - Life Cycle
    
    init(title: String, viewType: navigationViewType) {
        self.viewType = viewType
        super.init(frame: .zero)
        
        setAddSubViews()
        setAutoLayout()
        setupDismissButton()
        setTitle(title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout Helpers

extension PobitNavigationBarView {
    private func setAddSubViews() {
        addSubViews([titleLabel, dividerView])
    }
    
    private func setAutoLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(LayoutLiterals.minimumHorizontalSpacing)
        }
        
        dividerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(LayoutLiterals.upperPrimarySpacing)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupDismissButton() {
        if viewType == .withDismissButton {
            addSubview(dismissButton)
            
            dismissButton.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.trailing.equalToSuperview().inset(LayoutLiterals.minimumHorizontalSpacing)
                make.size.equalTo(30)
            }
        }
    }
}

// MARK: - Methods

extension PobitNavigationBarView {
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
