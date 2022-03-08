//
//  Date+Extension.swift
//  GCCompanyDemo
//
//  Created by 박승태 on 2022/03/08.
//

import Foundation

extension Date {
    
    func convertToString() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분 ss초"
                
        return "등록시간: " + dateFormatter.string(from: self)
    }
}
