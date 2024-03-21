//
//  Date+Extension.swift
//  PomoHabit
//
//  Created by 원동진 on 2/27/24.
//

import Foundation

extension Date {
    func dateToString(format: String = "MM.dd") -> String {
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
    
    func comparisonDate(fromDate: Date) -> Int? { // 년도 월 일
        //Format해서 비교해주는 이유 : 완료 시간과 목데이터의 시간이 다를 경우도 있기 때문
        let dateformat = "yyyy-MM-dd"
        let targetString = self.dateToString(format: dateformat)
        let fromString = fromDate.dateToString(format: dateformat)
        let dateFormatter =  DateFormatter()
        
        dateFormatter.dateFormat = dateformat
        
        if let targetDate = dateFormatter.date(from: targetString), let fromDate = dateFormatter.date(from: fromString) {
            switch targetDate.compare(fromDate) {
            case .orderedAscending: // fromDate 이전 날짜
                return -1
                
            case .orderedSame: // fromDate 동일한 날짜
                return 0
                
            case .orderedDescending: // fromDate 이후 날짜
                return 1
            }
        }
        return nil
    }
    
    func extractTimeFromDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    
}
