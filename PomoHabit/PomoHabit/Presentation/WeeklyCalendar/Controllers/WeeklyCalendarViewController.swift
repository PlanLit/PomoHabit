//
//  WeeklyCalendarViewController.swift
//  PomoHabit
//
//  Created by 원동진 on 2/27/24.
//
import Combine
import UIKit

import SnapKit

// MARK: - WeeklyCalendarViewController

final class WeeklyCalendarViewController: BaseViewController {
    
    // MARK: - Properties
    
    private var weeklyDates: [Date] = []
    private var weeklyHabitState: [HabitState] = []
    private var weeklyCalendarViewModel: WeeklyCalendarViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Views
    
    private lazy var weeklyCalendarView: WeeklyCalendarView = {
        let view = WeeklyCalendarView()
//        view.dateDelegate = self

        return view
    }()
    
    // MARK: - init
    init(viewModel: WeeklyCalendarViewModel) {
        self.weeklyCalendarViewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        
        view = weeklyCalendarView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        weeklyCalendarView.moveToSelectedCell(weeklyDates: weeklyDates)
    }
    
    override func viewDidLayoutSubviews() { // 해당 메소드 안에서만 오토레이 아웃으로 설정된 UI/View의 Frame 사이즈를 알 수 있음
        super.viewDidLayoutSubviews()
        
        setUpWeeklyHabbitProgressView(progress: getWeeklyProgress())
    }
}

// MARK: - View 관련 Methods

extension WeeklyCalendarViewController {
    private func setUpWeeklyHabbitProgressView(progress : Float) {
        if progress != 0 {
            let weeklyCalendarViewWidth = weeklyCalendarView.frame.width
            let progressCircleOffset = Int(weeklyCalendarViewWidth * CGFloat(progress)) + 5
            
            weeklyCalendarView.setProgressCircleImg(offset: progressCircleOffset)
            weeklyCalendarView.setWeeklyHabitProgressView(progress: progress)
        }
    }
}

// MARK: Bindings

extension WeeklyCalendarViewController {
    private func bind() {
        weeklyCalendarViewModel.$weeklyHabitInfo.sink { todayHabitInfo in // 오늘 습관 정보 데이터
            self.weeklyCalendarView.setHabitInfoView(state: todayHabitInfo?.habitstate,
                                                     targetHabit: todayHabitInfo?.targetHabit,
                                                     duringTime: todayHabitInfo?.duringTime,
                                                     goalTime: todayHabitInfo?.goalTime)
            self.weeklyCalendarView.setNoteContentLabel(note: todayHabitInfo?.note ?? "메모")
        }.store(in: &cancellables)
        
        weeklyCalendarViewModel.$weeklyDates.sink { weeklyDates in // 날짜 정보
            self.weeklyCalendarView.setWeeklyDates(weeklyDates: weeklyDates)
            self.weeklyDates = weeklyDates
        }.store(in: &cancellables)
        
        weeklyCalendarViewModel.$weeklyHabitState.sink { weeklyHabitState in
            self.weeklyHabitState = weeklyHabitState
            self.weeklyCalendarView.setWeeklyHabitState(setData: weeklyHabitState)
        }.store(in: &cancellables)
    }
}


// MARK: - Data 관련 method

extension WeeklyCalendarViewController {
    
    private func getWeeklyProgress() -> Float {
        return Float(weeklyHabitState.filter{ $0 == .done }.count) / 7.0
    }
}




