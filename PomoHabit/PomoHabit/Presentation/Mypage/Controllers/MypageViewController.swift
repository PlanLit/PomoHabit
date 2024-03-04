//
//  MypageViewController.swift
//  PomoHabit
//
//  Created by 洪立妍 on 2/29/24.
//

import UIKit

import SnapKit

// MARK: - MyPageViewController

final class MyPageViewController: UIViewController {
    
    // MARK: - Properties
    
    private let myPageRootView = MyPageView()
    
    // MARK: - View Lifecycle
    
    override func loadView() {
        super.loadView()
        
        view = myPageRootView
    }
}

// MARK: - Life Cycle

//    override func viewDidLoad() {
//        super.viewDidLoad()
//}

// MARK: - Layout Helpers

extension MyPageViewController {
    private func setAddSubViews() {
        view.addSubview(myPageRootView)
    }
    private func setSetAutoLayout() {
        myPageRootView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
