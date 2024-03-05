//
//  PobitNavigationBarView.swift
//  PomoHabit
//
//  Created by 최유리 on 2/27/24.
//

import UIKit

import SnapKit

// MARK: - PobitNavigationBarView

final class PobitNavigationBarView: UIView {
    
    // MARK: - Properties
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Pretendard.bold(size: 25)
        
        return label
    }()
    
    private var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .pobitStone3
        
        return view
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        
        setAddSubViews()
        setAutoLayout()
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
            make.top.equalTo(titleLabel.snp.bottom).offset(LayoutLiterals.minimumVerticalSpacing)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension PobitNavigationBarView {
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
