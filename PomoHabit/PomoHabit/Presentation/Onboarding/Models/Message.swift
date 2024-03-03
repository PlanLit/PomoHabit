//
//  Message.swift
//  PomoHabit
//
//  Created by 최유리 on 2/29/24.
//

import Foundation

enum ChatType: CaseIterable {
    case receive
    case send
}

struct Model {
    let message: String
    let chatType: ChatType
}

