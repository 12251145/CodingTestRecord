//
//  TabBarPage.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/13.
//

import Foundation

enum TabBarPage: CaseIterable {
    case home, records
    
    func pageOrderNumber() -> Int {
        switch self {
        case .home: return 0
        case .records: return 1
        }
    }
}
