//
//  Double + Formatter.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/20.
//

import Foundation

extension Double {
    var oneFraction: String {
        return String(format: "%.1f", self)
    }
}
