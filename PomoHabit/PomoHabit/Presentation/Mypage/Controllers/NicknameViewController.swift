//
//  NicknameViewController.swift
//  PomoHabit
//
//  Created by 洪立妍 on 3/15/24.
//

import UIKit

import SnapKit

// MARK: - NicknameViewController

final class NicknameViewController: UIViewController {
    
    // MARK: - Properties
    
    private let nicknameEditView = NicknameEditView()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(nicknameEditView)
        nicknameEditView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
