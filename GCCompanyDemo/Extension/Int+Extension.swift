//
//  Int+Extension.swift
//  GCCompanyDemo
//
//  Created by 박승태 on 2022/03/06.
//

import Foundation

extension Int {
    
    var withComma: String {
        
        let decimalFormatter = NumberFormatter()
        decimalFormatter.numberStyle = NumberFormatter.Style.decimal
        decimalFormatter.groupingSeparator = ","
        decimalFormatter.groupingSize = 3
         
        return decimalFormatter.string(from: self as NSNumber) ?? ""
    }
}
