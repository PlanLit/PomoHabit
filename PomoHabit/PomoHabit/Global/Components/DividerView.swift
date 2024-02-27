//
//  BorderView.swift
//  PomoHabit
//
//  Created by 원동진 on 2/27/24.
//

import UIKit

// MARK: - DividerView

class DividerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpDividerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Layout Helpers

extension DividerView {
    private func setUpDividerView(){
        self.backgroundColor = UIColor.pobitStone3
        self.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }
}

