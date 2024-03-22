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
    
    private var nicknameEditView: NicknameEditView?
    var onDataReceived: ((String) -> Void)? = nil
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

// MARK: - Method

extension NicknameViewController {
//    func toReceiveNicknameData(data: String) {
//        onDataReceived?(data)
//        onDataReceived = nil
//    }
    
    func setupNicknameEditView(_ nickName: String) {
        nicknameEditView = NicknameEditView(frame: .zero, nickName, self)
        view.addSubview(nicknameEditView!)
        nicknameEditView?.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
