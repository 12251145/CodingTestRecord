//
//  KeyboardMonitor.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/22.
//

import Foundation
import Combine
import UIKit

final class KeyboardMonitor {
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillShowNotification)
            .sink { notification in
                print("Keyboard will show.")
            }
            .store(in: &subscriptions)
        
        NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillHideNotification)
            .sink { notification in
                print("Keyboard will hide.")
            }
            .store(in: &subscriptions)
        
        NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardDidChangeFrameNotification)
            .sink { notification in
                print("Keyboard frame will change.")
            }
            .store(in: &subscriptions)
    }
}
