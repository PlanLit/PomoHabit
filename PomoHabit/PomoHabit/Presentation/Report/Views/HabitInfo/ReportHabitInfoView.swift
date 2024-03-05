//
//  ReportHabitInfoViewController.swift
//  PomoHabit
//
//  Created by JiHoon K on 2/29/24.
//

import UIKit

// MARK: - ReportHabitInfoViewController

final class ReportHabitInfoView: BaseView {
    
    // MARK: - Properties
    
    private lazy var tableView: UITableView = makeTableView()
    
    private var dayButtonSelectionStates = [true, true, true, true, false, false, false] // 유저가 입력했던 월화수 데이터 (임시)
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubviews()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout Helpers

extension ReportHabitInfoView {
    private func setAddSubviews() {
        self.addSubview(tableView)
    }
    
    private func setAutoLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.trailing.equalTo(self.snp.trailing).offset(-LayoutLiterals.minimumHorizontalSpacing)
            make.bottom.equalTo(self.snp.bottom)
            make.leading.equalTo(self.snp.leading).offset(LayoutLiterals.minimumHorizontalSpacing)
        }
    }
}

// MARK: - Factory Methods

extension ReportHabitInfoView {
    private func makeTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(ReportDayButtonTableViewCell.self, forCellReuseIdentifier: "\(ReportDayButtonTableViewCell.self)")
        tableView.register(ReportDayButtonTableViewCell.self, forCellReuseIdentifier: "StartTimeCell")
        
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

extension ReportHabitInfoView: UITableViewDataSource {
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
            cell.dayButtonSelectionStates = dayButtonSelectionStates
            
            return cell
        case 1:
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
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate

extension ReportHabitInfoView: UITableViewDelegate {
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
