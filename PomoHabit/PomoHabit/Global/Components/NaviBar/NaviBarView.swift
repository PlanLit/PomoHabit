//
//  NaviBarView.swift
//  PomoHabit
//
//  Created by 최유리 on 2/27/24.
//

import UIKit

import SnapKit

// MARK: - NaviBarView

class NaviBarView: UIView {
    
    // MARK: - Properties
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 25)
        
        return label
    }()
    
    private var divider: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: - Layout Helpers

extension NaviBarView {
    
    private func setUI() {
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(divider)
        
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.centerY.equalTo(self.snp.centerY)
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.width.equalTo(430)
            $0.height.equalTo(1)
        }
    }
}

// MARK: - Methods

extension NaviBarView {
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
