//
//  NoteView.swift
//  PomoHabit
//
//  Created by 원동진 on 2/26/24.
//

import UIKit

import SnapKit

// MARK: - BaseView

final class NoteView: BaseView {
    private let noteLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24) // CustomFont
        label.textColor = UIColor.gray// Color Asset추가 필요
        label.text = "메모"
        label.textAlignment = .left
        return label
    }()
    
    private lazy var noteTextView = NoteTextView()
    
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
        self.addSubViews([noteLabel,noteTextView])
    }
    
    private func setAutoLayout() {
        noteLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24) // Spacing Static 설정 필요
            make.leading.equalToSuperview().offset(20) // Spacing Static 설정 필요
            make.trailing.equalToSuperview().offset(-20) // Spacing Static 설정 필요
        }
        
        noteTextView.snp.makeConstraints { make in
            make.top.equalTo(noteLabel.snp.bottom).offset(12) // Spacing Static 설정 필요
            make.leading.equalToSuperview().offset(20) // Spacing Static 설정 필요
            make.trailing.equalToSuperview().offset(-20) // Spacing Static 설정 필요
            make.bottom.equalToSuperview().offset(-24) // Spacing Static 설정 필요
        }
    }
}

// MARK: - Public Methods

extension NoteView {
    public func getNoteTextViewText() -> String{
        return noteTextView.text
    }

}

