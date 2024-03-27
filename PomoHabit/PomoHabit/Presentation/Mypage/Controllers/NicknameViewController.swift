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
    var onDataReceived: ((String) -> Void)? 
    var onNicknameEdit: ((String) -> Void)?
    var onDataReceivedFromMyPage: (() -> Void)?
    var nicknameLabelPlaceholder: String?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNicknameEditView()
        setDelegate()
        nicknameEditView.editSubmitButton.addTarget(self, action: #selector(didTapNicknameSubmitButton) , for: .touchUpInside)
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
        
        onNicknameEdit?(nickname)
        onDataReceivedFromMyPage?()
        dismiss(animated: true)
    }
}
