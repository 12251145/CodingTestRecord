//
//  countSummary.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/20.
//

import Foundation

struct CountSummary: Identifiable {
    var index: Int
    var count: Double
    
    var id: Int { index }
}
