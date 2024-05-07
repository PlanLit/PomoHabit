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
    var nicknameLabelPlaceholder: String?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNicknameEditView()
        setDelegate()
        setupEditSubmitButton()
        placeholderContent ()
        didTapNicknameSubmitButton()
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
        Snackbar.showSnackbar(in: self.view, title: "안녕", message: "수정페이지")
    }
    
    func setOnDataReceivedHandler(handler: ((String) -> Void)?) {
        self.onDataReceived = handler
    }
    
    func getOnDataReceivedHandler() -> ((String) -> Void)? {
        
        return self.onDataReceived
    }
    
    func setNicknameLabelPlaceholder(placeholder: String?) {
        self.nicknameLabelPlaceholder = placeholder
    }
    
    func getNicknameLabelPlaceholder() -> String? {
        
        return self.nicknameLabelPlaceholder
    }
}
