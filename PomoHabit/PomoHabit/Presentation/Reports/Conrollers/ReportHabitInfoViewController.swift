//
//  ReportHabitInfoViewController.swift
//  PomoHabit
//
//  Created by JiHoon K on 2/29/24.
//

import UIKit

// MARK: - ReportHabitInfoViewController

final class ReportHabitInfoViewController: BaseViewController {
    
    // MARK: - Properties
    
    private var tableView: UITableView?
    
    private var dayButtonSelectionStates = [true, true, true, true, false, false, false] // 유저가 입력했던 월화수 데이터 (임시)
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        
        setAddSubviews()
        setAutoLayout()
    }
}

// MARK: - Layout Helpers

extension ReportHabitInfoViewController {
    private func setUpTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.register(ReportDayButtonCell.self, forCellReuseIdentifier: "\(ReportDayButtonCell.self)")
        tableView?.register(ReportDayButtonCell.self, forCellReuseIdentifier: "StartTimeCell")
    }
    
    private func setAddSubviews() {
        view.addSubview(tableView ?? UIView())
    }
    
    private func setAutoLayout() {
        tableView?.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func getHeaderLabelView(_ title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = Pretendard.bold(size: 20)
        label.textColor = .secondaryLabel
        
        return label
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
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ReportDayButtonCell.self)", for: indexPath) as? ReportDayButtonCell else { return UITableViewCell() }
            cell.dayButtonSelectionStates = dayButtonSelectionStates
            
            return cell
        } else if indexPath.section == 1 {
            let cell = UITableViewCell()
            cell.isUserInteractionEnabled = false
            
            let label = UILabel()
            label.text = "8 : 40 AM"
            label.font = Pretendard.bold(size: 20)
            label.textColor = .secondaryLabel
            
            let container = HStackView(alignment: .center,[
                label
            ])
            
            cell.contentView.addSubview(container)
            
            return cell
        }

        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate

extension ReportHabitInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return getHeaderLabelView("습관 실행 요일")
        } else if section == 1 {
            return getHeaderLabelView("습관 실행 시간")
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
}
