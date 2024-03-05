//
//  ReportHabitEditView.swift
//  PomoHabit
//
//  Created by JiHoon K on 2/29/24.
//

import UIKit

// MARK: - ReportHabitEditViewController

final class ReportHabitEditView: BaseView { // 구현 중
    
    // MARK: - Properties

    private lazy var headerView: VStackView = makeHeaderView()
    
    private lazy var mainContainerView: VStackView = makeMainContainerView()
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubviews()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ReportHabitEditView {
    private func setAddSubviews() {
        addSubViews([
            headerView,
            mainContainerView
        ])
    }
    
    private func setAutoLayout() {
        headerView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(50)
            make.trailing.equalTo(self.snp.trailing).offset(-LayoutLiterals.minimumHorizontalSpacing)
            make.leading.equalTo(self.snp.leading).offset(LayoutLiterals.minimumHorizontalSpacing)
        }
        
        mainContainerView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(LayoutLiterals.upperPrimarySpacing)
            make.trailing.equalTo(self.snp.trailing).offset(-LayoutLiterals.minimumHorizontalSpacing)
            make.leading.equalTo(self.snp.leading).offset(LayoutLiterals.minimumHorizontalSpacing)
        }
    }
}

// MARK: - Factory Methods

extension ReportHabitEditView {
    private func makeHeaderView() -> VStackView {
        let dateLabel = {
            let label = UILabel()
            label.text = "02.21 수요일"
            label.font = Pretendard.bold(size: 20)
            label.textColor = .darkGray
            
            return label
        }()
        
        return VStackView([
            UILabel().setPrimaryColorLabel(text: "Date"),
            dateLabel,
        ])
    }
    
    private func makeMainContainerView() -> VStackView {
        let dividerView = {
            let view = UIView()
            view.backgroundColor = .lightGray
            view.snp.makeConstraints { make in
                make.height.equalTo(0.5)
            }
            
            return view
        }()
        
        let trashButton = {
            let button = PobitButton(primaryAction: .init(handler: { _ in
                
            }))
            button.setImage(UIImage(systemName: "trash"), for: .normal)
            button.tintColor = .pobitStone1
            button.layer.borderColor = UIColor.pobitRed.cgColor
            button.layer.cornerRadius = 10
            button.snp.makeConstraints { make in
                make.width.equalTo(62)
            }
            
            return button
        }()
        
        let registButton = {
            let button = PobitButton.makePlainButton(title: "수정하기", backgroundColor: .pobitRed)
            button.layer.cornerRadius = 10
            
            return button
        }()
        
        let textView = NoteTextView()
        
        let bottomButtonContainer = HStackView(alignment: .fill, distribution: .fill, [
            trashButton,
            registButton
        ])
        
        bottomButtonContainer.snp.makeConstraints { make in
            make.height.equalTo(62)
        }
        
        textView.snp.makeConstraints { make in
            make.height.equalTo(300)
        }
        
        return VStackView(spacing: CGFloat(LayoutLiterals.upperPrimarySpacing), alignment: .fill, [
            dividerView,
            HStackView(spacing: 5, alignment: .fill, distribution: .fill, [
                makeTextLabel("목표시간", Pretendard.bold(size: 20), .darkGray),
                makeTextLabel(":", Pretendard.bold(size: 20), .darkGray),
                makeTextLabel("5분", Pretendard.medium(size: 20), .darkGray),
                UIView()
            ]),
            makeTextLabel("메모", Pretendard.bold(size: 24), .darkGray),
            textView,
            bottomButtonContainer
        ])
    }
    
    private func makeTextLabel(_ text: String,_ font: UIFont?,_ color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = color
        
        return label
    }
}
