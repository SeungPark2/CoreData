//
//  Array+Extension.swift
//  GCCompanyDemo
//
//  Created by 박승태 on 2022/03/07.
//

import Foundation

extension Array {
    
    subscript (safe index: Int) -> Element? {

        return indices ~= index ? self[index] : nil
    }
}
