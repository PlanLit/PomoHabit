//
//  Message.swift
//  PomoHabit
//
//  Created by 최유리 on 2/29/24.
//

import Foundation

struct OnboardingModel {
    var message: String
    var chatType: ChatType
    
    enum ChatType: CaseIterable {
        case receive
        case send
    }
}
