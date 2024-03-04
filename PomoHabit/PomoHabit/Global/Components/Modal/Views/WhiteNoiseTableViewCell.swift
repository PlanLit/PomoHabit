//
//  WhiteNoiseTableViewCell.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/29.
//

import UIKit

import SnapKit

// MARK: - WhiteNoiseTableViewCell

final class WhiteNoiseTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "WhiteNoiseTableViewCell"
    
    // MARK: - UI Properties
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "비내리는 아침"
        return label
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.setTitle("재생", for: .normal)
        return button
    }()

    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setAddSubViews()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}

// MARK: - Layout Helpers

extension WhiteNoiseTableViewCell {
    private func setAddSubViews() {
        addSubViews([titleLabel, playButton])
    }
    
    private func setAutoLayout() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.leading.equalToSuperview()
        }
        
        playButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview()
        }
    }
}

// MARK: - Action Helpers

extension WhiteNoiseTableViewCell {
    func bindCell(with title: String) {
        titleLabel.text = title
    }
}


