//
//  WeeklyCalendarViewController.swift
//  PomoHabit
//
//  Created by 원동진 on 2/27/24.
//

import UIKit

// MARK: - WeeklyCalendarViewController

class WeeklyCalendarViewController: BaseViewController {

    // MARK: - Properties
    
    let weeklyCalendarView = WeeklyCalendarView()
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAddSubViews()
        setSetAutoLayout()
    }
}

// MARK: - Layout Helpers

extension WeeklyCalendarViewController {
    private func setAddSubViews() {
        view.addSubview(weeklyCalendarView)
    }
    
    private func setSetAutoLayout() {
        weeklyCalendarView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Action Helpers

extension WeeklyCalendarViewController {
    @objc private func name() {
    }
}

// MARK: - Methods

extension WeeklyCalendarViewController {

}

// MARK: - Private Methods

extension WeeklyCalendarViewController {

}


