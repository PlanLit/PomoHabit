//
//  TimerViewController.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/27.
//

import UIKit

// MARK: - TimerViewController

final class TimerViewController: BaseViewController {
    
    // MARK: - Properties
    
    private var rootView = TimerView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension TimerViewController {

}
