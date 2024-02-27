//
//  PobitNavigationBarView.swift
//  PomoHabit
//
//  Created by 최유리 on 2/27/24.
//

import UIKit

import SnapKit

// MARK: - PobitNavigationBarView

class PobitNavigationBarView: UIView {
    
    // MARK: - Properties
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        
        return label
    }()
    
    private var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubViews()
        setAutoLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: - Layout Helpers

extension NaviBarView {
    private func setAddSubViews() {
        self.addSubViews([titleLabel, dividerView])
    }
    
    private func setAutoLayout() {
        backgroundColor = .white
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        dividerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.width.equalTo(430)
            make.height.equalTo(1)
        }
    }
}

// MARK: - Methods

extension NaviBarView {
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
