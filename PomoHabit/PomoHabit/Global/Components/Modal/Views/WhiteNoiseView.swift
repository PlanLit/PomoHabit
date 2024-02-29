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
    
    private let whiteNoiseLabel = UILabel().setPrimaryColorLabel(text: "White Noise")
    private let editButton = PobitButton.makeSquareButton(title: "수정")
    
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
        addSubViews([whiteNoiseLabel, editButton, tableView])
        
    }
    
    private func setAutoLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
