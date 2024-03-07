//
//  OnboardingChattingCellData.swift
//  PomoHabit
//
//  Created by JiHoon K on 3/7/24.
//

import Foundation

struct OnboardingChattingCellData {
    var chatDirection: ChatDirection
    var message: String?
    var cellType: CellType?
    
    enum ChatDirection {
        case incoming
        case outgoing
    }
    
    enum CellType {
        case profilePicture
        case title
        case days
        case time
    }
}
