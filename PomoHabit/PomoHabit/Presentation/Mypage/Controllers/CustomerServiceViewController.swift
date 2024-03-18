//
//  CSViewController.swift
//  PomoHabit
//
//  Created by 洪立妍 on 3/15/24.
//

import UIKit

import SnapKit

final class CustomerServiceViewController: UIViewController {
    
    // MARK: - Properties
    
    private let contactEmailLabel: UILabel = {
        let label = UILabel()
        label.text = "연락처: joonbaek12@gmail.com"
        label.textAlignment = .center
        label.textColor = .pobitStone2
        label.font = Pretendard.bold(size: 20)
        
        return label
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setAddSubviews()
        setupConstraints()
    }
    
    // MARK: - UI Setup
    
    private func setAddSubviews() {
        view.addSubview(contactEmailLabel)
    }
    
    private func setupConstraints() {
        contactEmailLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
