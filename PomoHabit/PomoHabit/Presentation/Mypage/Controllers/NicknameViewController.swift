//
//  NicknameViewController.swift
//  PomoHabit
//
//  Created by 洪立妍 on 3/15/24.
//

import UIKit

import SnapKit

// MARK: - NicknameViewController

final class NicknameViewController: UIViewController, NavigationBarDelegate {
    
    // MARK: - Properties
    
    private let nicknameEditView = NicknameEditView()
//    var onDataReceived: ((String) -> Void)? = nil
    var onNicknameEdit: ((String) -> Void)?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        setupNicknameEditView()
        nicknameEditView.editSubmitButton.addTarget(self, action: #selector(didTapNicknameSubmitButton) , for: .touchUpInside)
        
    }
}

// MARK: - Method

extension NicknameViewController {
    private func setDelegate() {
        nicknameEditView.setNavigationBarDelegate(self: self)
    }
    
    func toReceiveNicknameData(data: String) {
//        onDataReceived?(data)
//        onDataReceived = nil
    }
    
    private func setupNicknameEditView() {
        view.addSubview(nicknameEditView)
        nicknameEditView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func didTapNicknameSubmitButton() {
        guard let nickname = nicknameEditView.nicknameEditTextField.text else { return }
        
        onNicknameEdit?(nickname)
        dismiss(animated: true)
    }
}
