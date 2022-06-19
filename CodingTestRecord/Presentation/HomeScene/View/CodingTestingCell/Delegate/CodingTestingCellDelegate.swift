//
//  CodingTestingCellDelegate.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/18.
//

import Foundation

protocol CodingTestingCellDelegate {
    func updatePassState(index: Int, kind: PassKind, isPass: Bool)
    
    func reloadTableView()
}
