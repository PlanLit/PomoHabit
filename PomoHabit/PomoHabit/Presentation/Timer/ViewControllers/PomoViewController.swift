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
    private var whiteNoiseView = WhiteNoiseViewController()
    
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
                                         timerButtonTapped: rootView.timerButtonTapped,
                                         submitButtonTapped: whiteNoiseView.submitButtonTapped, 
                                         whiteNoiseSelected: whiteNoiseView.whiteNoiseSelectedSubject)
        let output = model.transform(input: input)
        
        output.memoButtonAction
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.presentBottomSheet(viewController: MemoViewController())
            }
            .store(in: &cancellables)
        
        output.whiteNoiseButtonAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.presentBottomSheet(viewController: self?.whiteNoiseView ?? WhiteNoiseViewController(), detents: [.medium()])
            }
            .store(in: &cancellables)
        
        output.submitButtonAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .store(in: &cancellables)
        
        output.timerButtonAction
            .sink { _ in }
            .store(in: &cancellables)
        
        output.timerStateDidChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.rootView.updateTimerButtonUI(with: state)
                self?.rootView.circleProgressBar.updateProgressBarUI(with: state)
                
                switch state {
                case .stopped:
                    break
                case .running:
                    self?.rootView.circleProgressBar.setProgressWithAnimation(duration: self?.model.timerDuration ?? 5)
                case .finished:
                    self?.rootView.updateTimerButtonUI(with: state)
                case .done:
                    self?.showAlert(title: "오늘의 습관을 완료했어요!", message: "\n 내일 다시 만나요 :)", cancelButton: false)
                }
            }
            .store(in: &cancellables)
        
        output.remainingTime
            .receive(on: DispatchQueue.main)
            .sink { [weak self] remainingTime in
                self?.rootView.circleProgressBar.updateTimeLabel(remainingTime)
            }
            .store(in: &cancellables)
        
        output.userData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userData in
                self?.rootView.updateViewWithUserData(userData)
            }
            .store(in: &cancellables)
    }
}
