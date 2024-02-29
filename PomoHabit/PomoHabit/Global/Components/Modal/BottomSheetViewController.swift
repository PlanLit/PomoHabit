//
//  BottomSheetViewController.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/28.
//

import UIKit

// MARK: - BottomSheetViewController

final class BottomSheetViewController: BaseViewController {
    
    // MARK: - UI Properties
    
    private var rootView: UIView
    
    // MARK: - Life Cycle

    init(rootView: UIView) {
        self.rootView = rootView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
}
