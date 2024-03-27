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
    
    private var onDataReceived: ((String) -> Void)?
    private var onNicknameEdit: ((String) -> Void)?
    private var nicknameLabelPlaceholder: String?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNicknameEditView()
        setDelegate()
        setupEditSubmitButton()
        placeholderContent ()
    }
}

// MARK: - Method

extension NicknameViewController {
    private func setDelegate() {
        nicknameEditView.setNavigationBarDelegate(self: self)
    }
    
    func toReceiveNicknameData(data: String) {
        onDataReceived?(data)
        onDataReceived = nil
    }
    
    func placeholderContent () {
        nicknameEditView.nicknameEditTextField.placeholder = nicknameLabelPlaceholder
    }
    
    private func setupNicknameEditView() {
        view.addSubview(nicknameEditView)
        nicknameEditView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func didTapNicknameSubmitButton() {
        guard let nickname = nicknameEditView.nicknameEditTextField.text else { return }
        CoreDataManager.shared.updateUsernickName(nickname:nickname)
        onNicknameEdit?(nickname)
        dismiss(animated: true)
    }
    
    func setupEditSubmitButton() {
        nicknameEditView.editSubmitButton.addTarget(self, action: #selector(didTapNicknameSubmitButton) , for: .touchUpInside)
    }
}
