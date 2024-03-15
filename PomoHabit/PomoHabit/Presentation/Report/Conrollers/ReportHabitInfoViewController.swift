//
//  ReportHabitInfoViewController.swift
//  PomoHabit
//
//  Created by JiHoon K on 2/29/24.
//

import UIKit

// MARK: - ReportHabitInfoViewController

final class ReportHabitInfoViewController: BaseViewController {
    
    // MARK: - Data Properties
    
    private var daysButtonSelectionState: [Bool]? // 유저가 입력했던 월화수 데이터 (임시)
    private var startTime: String?
    
    // MARK: - UI Properties
    
    private lazy var tableView: UITableView = makeTableView()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setAddSubviews()
        setAutoLayout()
    }
}

// MARK: - Layout Helpers

extension ReportHabitInfoViewController {
    private func setAddSubviews() {
        self.view.addSubview(tableView)
    }
    
    private func setAutoLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.top)
            make.trailing.equalTo(self.view.snp.trailing).offset(-LayoutLiterals.minimumHorizontalSpacing)
            make.bottom.equalTo(self.view.snp.bottom)
            make.leading.equalTo(self.view.snp.leading).offset(LayoutLiterals.minimumHorizontalSpacing)
        }
    }
    
    func setData(_ daysButtonSelectionState: [Bool]?,_ startTime: String?) {
        self.daysButtonSelectionState = daysButtonSelectionState
        self.startTime = startTime
    }
}

// MARK: - Factory Methods

extension ReportHabitInfoViewController {
    private func makeTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }
    
    private func makeHeaderLabelView(_ title: String) -> UILabel {
        let label = UILabel()
        label.backgroundColor = .white
        label.text = title
        label.font = Pretendard.bold(size: 20)
        label.textColor = .secondaryLabel
        
        return label
    }
    
    private func makeSeparatorView() -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        
        containerView.addSubview(separatorView)
        
        separatorView.snp.makeConstraints { make in
            make.trailing.equalTo(containerView.snp.trailing)
            make.bottom.equalTo(containerView.snp.bottom)
            make.leading.equalTo(containerView.snp.leading)
            make.height.equalTo(0.5)
        }
        
        return containerView
    }
}

// MARK: - UITableViewDataSource

extension ReportHabitInfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = ReportDayButtonTableViewCell()
            cell.setData(daysButtonSelectionState)
            
            return cell
        case 1:
            let cell = UITableViewCell()
            cell.isUserInteractionEnabled = false

            let label = UILabel()
            label.text = self.startTime
            label.font = Pretendard.bold(size: 20)
            label.textColor = .secondaryLabel
            
            let container = HStackView(alignment: .center,[
                label
            ])
            
            cell.contentView.addSubview(container)
            
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate

extension ReportHabitInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return makeHeaderLabelView("습관 실행 요일")
        } else if section == 1 {
            return makeHeaderLabelView("습관 실행 시간")
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section%2 == 0 && section != tableView.numberOfSections - 1 {
            return makeSeparatorView()
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40.25
    }
}
