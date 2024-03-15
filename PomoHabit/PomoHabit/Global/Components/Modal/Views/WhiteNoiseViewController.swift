//
//  WhiteNoiseView.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/29.
//

import UIKit

import SnapKit

// MARK: - WhiteNoiseView

final class WhiteNoiseViewController: BaseViewController {

    // MARK: - UI Properties
  
    private lazy var navigationBar = PobitNavigationBarView(title: "백색소음", viewType: .withDismissButton)
    
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
    
    override func viewDidLoad() {
        setAddSubViews()
        setAutoLayout()
    }
}

// MARK: - Layout Helpers

extension WhiteNoiseViewController {
    private func setAddSubViews() {
        view.addSubViews([navigationBar, whiteNoiseLabel, editButton, tableView])
    }
    
    private func setAutoLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(LayoutLiterals.upperPrimarySpacing)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(58)
        }
        
        whiteNoiseLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(LayoutLiterals.upperPrimarySpacing)
            make.leading.equalToSuperview().offset(LayoutLiterals.minimumHorizontalSpacing)
        }
        
        editButton.snp.makeConstraints { make in
            make.centerY.equalTo(whiteNoiseLabel)
            make.trailing.equalToSuperview().offset(-LayoutLiterals.minimumHorizontalSpacing)
            make.size.equalTo(24)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(whiteNoiseLabel.snp.bottom).offset(LayoutLiterals.upperSecondarySpacing)
            make.leading.equalTo(whiteNoiseLabel)
            make.trailing.equalTo(editButton)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDelegate

extension WhiteNoiseViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource

extension WhiteNoiseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WhiteNoiseTableViewCell.identifier, for: indexPath) as? WhiteNoiseTableViewCell else {
            return UITableViewCell()}
        
        cell.selectionStyle = .none
        cell.bindCell(with: tempModel[indexPath.item])
        
        return cell
    }
}
