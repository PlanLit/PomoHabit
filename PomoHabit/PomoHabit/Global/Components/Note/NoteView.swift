//
//  NoteView.swift
//  PomoHabit
//
//  Created by 원동진 on 2/26/24.
//

import UIKit

import SnapKit

//MARK: - View

class NoteView: BaseView {
    private let noteLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24) // CustomFont
        label.textColor = UIColor.gray// Color Asset추가 필요
        label.text = "메모"
        label.textAlignment = .left
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubViews()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:\(coder) has not been implemented")
    }
    
}

// MARK: - Layout Helpers

extension NoteView {
    
    private func setAddSubViews() {
        self.addSubViews([noteLabel])
    }
    
    private func setAutoLayout() {
        noteLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100) // 임시 설정값
            make.left.equalToSuperview().offset(20) // Spacing Static 설정 필요
            make.right.equalToSuperview().offset(-20)
        }
    }
}
