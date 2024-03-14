//
//  TimerViewController.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/27.
//

import Combine
import UIKit

// MARK: - TimerViewController

final class TimerViewController: BaseViewController, BottomSheetPresentable {
    
    // MARK: - Properties
    
    private var model = TimerViewModel()
    private var rootView = TimerView()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
}

// MARK: - Bindings

extension TimerViewController {
    private func bind() {
        let input = TimerViewModel.Input(memoButtonTapped: rootView.memoButtonTapped,
                                     whiteNoiseButtonTapped: rootView.whiteNoiseButtonTapped,
                                     timerButtonTapped: rootView.timerButtonTapped)
        let output = model.transform(input: input)
        
        output.memoButtonAction
            .sink { _ in
                DispatchQueue.main.async {
                    self.presentBottomSheet(rootView: MemoView())
                }
            }
            .store(in: &cancellables)
        
        output.whiteNoiseButtonAction
            .sink { _ in
                DispatchQueue.main.async {
                    self.presentBottomSheet(rootView: WhiteNoiseView(), detents: [.medium()])
                }
            }
            .store(in: &cancellables)
        
        output.timerButtonAction
            .sink { _ in
                
            }
            .store(in: &cancellables)
        
        output.timerStateDidChange
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                self?.rootView.updateTimerButtonState(state)
                if state == .running {
                    self?.rootView.circleProgressBar.setProgressWithAnimation(duration: self?.model.timerDuration ?? 5)
                } else {
                    self?.rootView.circleProgressBar.resetProgressAnimation()
                }
            }
            .store(in: &cancellables)
        
        output.remainingTime
            .receive(on: RunLoop.main)
            .sink { [weak self] remainingTime in
                self?.rootView.circleProgressBar.updateTimeLabel(remainingTime)
            }
            .store(in: &cancellables)
        
        output.userData
            .receive(on: RunLoop.main)
            .sink { [weak self] userData in
                self?.rootView.updateViewWithUserData(userData)
            }
            .store(in: &cancellables)
    }
}
