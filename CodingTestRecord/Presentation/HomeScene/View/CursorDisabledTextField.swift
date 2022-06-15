//
//  CursorDisabledTextField.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/15.
//

import UIKit

final class CursorDisabledTextField: UITextField {
    override func closestPosition(to point: CGPoint) -> UITextPosition? {
        let beginning = self.beginningOfDocument
        let end = self.position(from: beginning, offset: self.text?.count ?? 0)
        return end
    }
}
