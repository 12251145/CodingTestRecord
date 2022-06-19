//
//  Series.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/20.
//

import Foundation

struct Series: Identifiable {
    let type: String
    let count: [CountSummary]
    
    var id: String
}
