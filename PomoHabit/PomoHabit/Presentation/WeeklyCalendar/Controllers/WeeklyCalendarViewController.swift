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
    
    private lazy var weeklyCalendarView = WeeklyCalendarView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAddSubViews()
        setSetAutoLayout()
        
    }
    
    override func viewDidLayoutSubviews() { // 해당 메소드 안에서만 오토레이 아웃으로 설정된 UI/View의 Frame 사이즈를 알 수 있음
        super.viewDidLayoutSubviews()
        
        setUpWeeklyHabbitProgressView(progress: 0.6)
    }
}

// MARK: - Layout Helpers

extension WeeklyCalendarViewController {
    private func setAddSubViews() {
        view.addSubview(weeklyCalendarView)
    }
    
    private func setSetAutoLayout() {
        weeklyCalendarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
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
    private func setUpWeeklyHabbitProgressView(progress : Float){
        let weeklyCalendarViewWidth = weeklyCalendarView.frame.width
        let progressCircleOffset = Int(weeklyCalendarViewWidth * CGFloat(progress)) - 5
        
        weeklyCalendarView.setProgressCircleImg(offset: progressCircleOffset)
        weeklyCalendarView.setWeeklyHabbitProgressView(progress: progress)
    }
}

// MARK: - Private Methods

extension WeeklyCalendarViewController {
    
}


