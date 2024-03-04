//
//  WhiteNoiseView.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/29.
//

import UIKit

import SnapKit

// MARK: - WhiteNoiseView

final class WhiteNoiseView: BaseView {

    // MARK: - UI Properties
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .pobitStone2
        
        return button
    }()
    
    private let whiteNoiseLabel = UILabel().setPrimaryColorLabel(text: "White Noise")
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .pobitStone3
        
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WhiteNoiseTableViewCell.self,
                           forCellReuseIdentifier: WhiteNoiseTableViewCell.identifier)
        
        return tableView
    }()
    
    let tempModel = ["비 내리는 아침", "고요한 밤의 소리", "잔잔한 파도의 위로"]
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubViews()
        setAutoLayout()
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout Helpers

extension WhiteNoiseView {
    private func setAddSubViews() {
        addSubViews([dismissButton, whiteNoiseLabel, editButton, tableView])
    }
    
    private func setAutoLayout() {
        dismissButton.snp.makeConstraints { make in
            make.top.equalTo(LayoutLiterals.upperPrimarySpacing)
            make.leading.equalToSuperview().offset(LayoutLiterals.minimumHorizontalSpacing)
            make.size.equalTo(24)
        }
        
        whiteNoiseLabel.snp.makeConstraints { make in
            make.top.equalTo(dismissButton.snp.bottom).offset(LayoutLiterals.upperPrimarySpacing)
            make.leading.equalTo(dismissButton)
        }
        
        editButton.snp.makeConstraints { make in
            make.centerY.equalTo(whiteNoiseLabel)
            make.trailing.equalToSuperview().offset(-LayoutLiterals.minimumHorizontalSpacing)
            make.size.equalTo(24)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(whiteNoiseLabel.snp.bottom).offset(LayoutLiterals.upperSecondarySpacing)
            make.leading.equalTo(dismissButton)
            make.trailing.equalTo(editButton)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDelegate

extension WhiteNoiseView: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource

extension WhiteNoiseView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WhiteNoiseTableViewCell.identifier, for: indexPath) as? WhiteNoiseTableViewCell else {
            return UITableViewCell()}
        
        cell.bindCell(with: tempModel[indexPath.item])
        
        return cell
    }
}
