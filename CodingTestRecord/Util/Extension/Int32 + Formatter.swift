//
//  Int + Formatter.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/14.
//

import Foundation

extension Int32 {
    var hhmmss: String {
        if self < 0 { return "00:00:00" }
        
        let s = self % 60
        let m = self / 60 % 60
        let h = self / 3600
        
        let ss = s < 10 ? "0\(s)" : "\(s)"
        let mm = m < 10 ? "0\(m)" : "\(m)"
        let hh = h < 10 ? "0\(h)" : "\(h)"
        
        return "\(hh)시 \(mm)분 \(ss)초"
    }
    
    var hhmm: String {
        if self < 0 { return "0시간" }

        let m = self / 60 % 60
        let h = self / 3600

        let mm = m == 0 ? "0\(m)" : "\(m)"
        let hh = "\(h)"
        
        return "\(hh)시간 \(mm)분"
    }
}
