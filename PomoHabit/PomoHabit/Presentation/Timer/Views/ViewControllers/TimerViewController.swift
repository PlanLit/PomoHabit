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
    
    // MARK: - Subjects
    
    private let viewDidLoadSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Properties
    
    private var viewModel: TimerViewModel
    private var rootView: TimerView
    private lazy var whiteNoiseView = WhiteNoiseViewController()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(viewModel: TimerViewModel, rootView: TimerView) {
        self.viewModel = viewModel
        self.rootView = rootView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        viewDidLoadSubject.send()
    }
}

// MARK: - Bindings

extension TimerViewController {
    private func bind() {
        let input = TimerViewModel.Input(viewDidLoadSubject: viewDidLoadSubject,
                                         memoButtonTapped: rootView.timerHeaderView.memoButtonTapped,
                                         whiteNoiseButtonTapped: rootView.timerHeaderView.whiteNoiseButtonTapped,
                                         timerButtonTapped: rootView.timerButtonTapped,
                                         submitButtonTapped: whiteNoiseView.submitButtonTapped, 
                                         whiteNoiseSelected: whiteNoiseView.whiteNoiseSelected)
        let output = viewModel.transform(input: input)
        
        output.memoButtonAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.presentBottomSheet(viewController: MemoViewController())
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
        
        output.submitButtonAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
                self?.showAlert(title: "변경이 완료되었어요!", message: "", cancelButton: false)
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
                    self?.rootView.circleProgressBar.setProgressWithAnimation(duration: self?.viewModel.timerDuration ?? 5)
                case .finished:
                    self?.rootView.updateTimerButtonUI(with: state)
                    self?.whiteNoiseView.stop()
                    self?.showAlert(title: "메모를 작성하시겠어요?", message: nil) { [weak self] _ in
                        self?.presentBottomSheet(viewController: MemoViewController())
                    }
                case .done:
                    self?.showAlert(title: "오늘의 습관을 완료했어요!", message: "\n 내일은 수행 시간이 1분 늘어나요 :)", cancelButton: false)
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
                self?.rootView.timerHeaderView.updateViewWithUserData(userData)
            }
            .store(in: &cancellables)
    }
}
