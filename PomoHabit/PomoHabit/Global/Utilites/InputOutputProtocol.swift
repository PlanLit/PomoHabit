//
//  InputOutputProtocol.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/03/09.
//

protocol InputOutputProtocol {
    associatedtype Input
    associatedtype Output
       
    func transform(input: Input) -> Output
}
