//
//  ReportHabitDetailView.swift
//  PomoHabit
//
//  Created by JiHoon K on 2/29/24.
//

import UIKit

// MARK: - ReportHabitDetailView

final class ReportHabitDetailView: BaseView {
    
    // MARK: - Data Properties
    
    private var totalHabitInfo: TotalHabitInfo?
    
    // MARK: - UI Properties

    var reportViewController: ReportViewController?
    private lazy var headerView: VStackView = makeHeaderView()
    private lazy var mainContainerView: VStackView = makeMainContainerView()
    private lazy var noteFieldView: UITextView = NoteTextView()
    
    // MARK: - Life Cycles
    
    init(frame: CGRect,_ totalHabitInfo: TotalHabitInfo?) {
        super.init(frame: frame)
        
        self.totalHabitInfo = totalHabitInfo
        
        setAddSubviews()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}

extension ReportHabitDetailView {
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

extension ReportHabitDetailView {
    private func makeHeaderView() -> VStackView {
        let dateLabel = {
            let label = UILabel()
            label.text = totalHabitInfo?.date?.dateToString()
            label.font = Pretendard.bold(size: 50)
            label.textColor = .pobitBlack
            
            return label
        }()
        
        return VStackView([
            UILabel().setPrimaryColorLabel(text: totalHabitInfo?.date?.dateToString() ?? ""),
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
        
        let registButton = {
            let button = PobitButton(type: .system, primaryAction: .init(handler: { _ in
                CoreDataManager.shared.completedTodyHabit(completedDate: self.totalHabitInfo?.date ?? Date(), note: self.noteFieldView.text)
                self.reportViewController?.dismiss(animated: true)
            }))
            button.setTitle("수정하기", for: .normal)
            button.backgroundColor = .pobitRed
            button.tintColor = .white
            button.updateFont(font: Pretendard.medium(size: 24))
            button.layer.borderWidth = 0
            button.layer.cornerRadius = 10
            
            return button
        }()
        
        noteFieldView.text = totalHabitInfo?.note
        
        registButton.snp.makeConstraints { make in
            make.height.equalTo(62)
        }
        
        noteFieldView.snp.makeConstraints { make in
            make.height.equalTo(300)
        }
        
        return VStackView(spacing: CGFloat(LayoutLiterals.upperPrimarySpacing), alignment: .fill, [
            dividerView,
            HStackView(spacing: 5, alignment: .fill, distribution: .fill, [
                makeTextLabel("목표시간", Pretendard.bold(size: 20), .darkGray),
                makeTextLabel(":", Pretendard.bold(size: 20), .darkGray),
                makeTextLabel("\(totalHabitInfo?.goalTime ?? 5)분", Pretendard.medium(size: 20), .darkGray),
                UIView()
            ]),
            makeTextLabel("메모", Pretendard.bold(size: 24), .darkGray),
            noteFieldView,
            registButton
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
