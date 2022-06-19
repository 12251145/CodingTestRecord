//
//  Int + Formatter.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/18.
//

import Foundation

extension Int {
    var hhmmss: String {
        if self < 0 { return "00:00:00" }
        
        let s = self % 60
        let m = self / 60 % 60
        let h = self / 3600
        
        let ss = "\(s)"
        let mm = "\(m)"
        let hh = "\(h)"
        
        return h == 0 ? m == 0 ? "\(ss)초" : "\(mm)분 \(ss)초" : "\(hh)시 \(mm)분 \(ss)초"
    }
    
    var mm: String {
        if self < 0 { return "0분"}
        
        let m = self / 60
        
        return "\(m)분"
    }
}
