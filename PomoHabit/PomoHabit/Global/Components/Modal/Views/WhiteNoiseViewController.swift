//
//  WhiteNoiseView.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/29.
//

import AVFoundation
import Combine
import UIKit

import SnapKit

// MARK: - WhiteNoiseView

final class WhiteNoiseViewController: BaseViewController, NavigationBarDelegate {
    
    // MARK: - Subjects
    
    private (set) var submitButtonTapped = PassthroughSubject<Void, Never>()
    private (set) var whiteNoiseSelected = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Properties
    
    private var audioPlayer: AVAudioPlayer?
    private var selectedWhiteNosie: String?
    
    private let whiteNoiseMap: [String: String] = [
        "비 내리는 아침": "rainyMorning",
        "고요한 밤의 모닥불 소리": "campfire",
        "잔잔한 파도의 위로": "calmWaves"
    ]
    
    // MARK: - UI Properties
    
    private lazy var navigationBar = PobitNavigationBarView(title: "백색소음", viewType: .withDismissButton)
    private let whiteNoiseLabel = UILabel().setPrimaryColorLabel(text: "White Noise")
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WhiteNoiseTableViewCell.self,
                           forCellReuseIdentifier: WhiteNoiseTableViewCell.identifier)
        
        return tableView
    }()
    
    private lazy var submitButton: PobitButton = PobitButton.makePlainButton(title: "등록하기", backgroundColor: .pobitRed)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeSubmitButton()
        setDelegate()
        setAddSubViews()
        setAutoLayout()
    }
}

// MARK: - Setups

extension WhiteNoiseViewController {
    func subscribeSubmitButton() {
        submitButton.tapPublisher
            .sink{ [weak self] _ in
                self?.submitButtonTapped.send()
            }
            .store(in: &cancellables)
    }
    
    private func setDelegate() {
        navigationBar.delegate = self
    }
}

// MARK: - Layout Helpers

extension WhiteNoiseViewController {
    private func setAddSubViews() {
        view.addSubViews([navigationBar, whiteNoiseLabel, tableView, submitButton])
    }
    
    private func setAutoLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(LayoutLiterals.upperPrimarySpacing)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(58)
        }
        
        whiteNoiseLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(LayoutLiterals.upperPrimarySpacing)
            make.leading.equalToSuperview().offset(LayoutLiterals.minimumHorizontalSpacing)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(whiteNoiseLabel.snp.bottom).offset(LayoutLiterals.upperSecondarySpacing)
            make.leading.equalTo(whiteNoiseLabel)
            make.trailing.equalToSuperview().inset(LayoutLiterals.minimumHorizontalSpacing)
            make.bottom.equalTo(submitButton.snp.top)
        }
        
        submitButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(LayoutLiterals.lowerSecondarySpacing)
            make.leading.trailing.equalTo(tableView)
            make.height.equalTo(62)
        }
    }
}

// MARK: - Action Helpers

extension WhiteNoiseViewController {
    private func play(with title: String) {
        let url = Bundle.main.url(forResource: title, withExtension: "mp3")
        if let url = url {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print(error)
            }
        }
    }
    
    func stop() {
        audioPlayer?.stop()
    }
}

// MARK: - UITableViewDelegate

extension WhiteNoiseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = Array(whiteNoiseMap.keys)[indexPath.row]
        let selectedWhiteNosie = key
        self.selectedWhiteNosie = selectedWhiteNosie
        self.whiteNoiseSelected.send(self.selectedWhiteNosie ?? "")
        
        guard let fileName = whiteNoiseMap[key] else { return }
        play(with: fileName)
    }
}

// MARK: - UITableViewDataSource

extension WhiteNoiseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return whiteNoiseMap.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WhiteNoiseTableViewCell.identifier, for: indexPath) as? WhiteNoiseTableViewCell else {
            return UITableViewCell()}
        
        let key = Array(whiteNoiseMap.keys)[indexPath.row]
        cell.selectionStyle = .none
        cell.bindCell(with: key)
        
        return cell
    }
}
