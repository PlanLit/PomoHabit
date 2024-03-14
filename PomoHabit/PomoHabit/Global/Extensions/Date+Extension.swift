//
//  Date+Extension.swift
//  PomoHabit
//
//  Created by 원동진 on 2/27/24.
//

import Foundation

extension Date {
    func timeToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh : mm a"

        return dateFormatter.string(from: self)
    }
    
    func dateToString(format : String = "MM.dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        
        return formatter.string(from: self)
    }
    
    func getDayOfWeek() -> String { // 요일 구하는 함수
        let formatter = DateFormatter()
        
        formatter.dateFormat = "EEEEEE"
        formatter.locale = Locale(identifier: "ko_KR")
        
        let convertString = formatter.string(from: self)
        
        return convertString
    }
    
    func comparisonDate(targetDate: Date) -> Bool { // 년도 월 일
        //Format해서 비교해주는 이유 : 완료 시간과 목데이터의 시간이 다를 경우도 있기 때문
        if self.dateToString(format: "yyyy-MM-dd") == targetDate.dateToString(format: "yyyy-MM-dd"){
            return true
        } else {
            return false
        }
    }
}
