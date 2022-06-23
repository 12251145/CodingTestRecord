//
//  KeyboardMonitor.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/22.
//

import Foundation
import Combine
import UIKit

final class KeyboardMonitor: ObservableObject {
    enum Status {
        case show, hide
        var description: String {
            switch self {
            case .show: return "show"
            case .hide: return "hide"
            }
        }
    }
    
    var subscriptions = Set<AnyCancellable>()
    
    @Published var keyboardHeight: CGFloat = 0.0
    
    lazy var updatedKeyboardStatusAction: AnyPublisher<Status, Never> = $keyboardHeight
        .map { (height: CGFloat) -> KeyboardMonitor.Status in
            return height > 0 ? .show : .hide
        }
        .eraseToAnyPublisher()
    
    init() {
        NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillShowNotification)
            .merge(with:
                    NotificationCenter.Publisher(
                        center: NotificationCenter.default,
                        name: UIResponder.keyboardWillChangeFrameNotification)
            )
            .compactMap { (notification : Notification) -> CGRect in
                return notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            }
            .map { (keyboardFrame : CGRect) -> CGFloat in
                return keyboardFrame.height
            }
            .subscribe(Subscribers.Assign(object: self, keyPath: \.keyboardHeight))
        
        NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillHideNotification)
            .compactMap { (notification : Notification) -> CGFloat in
                return .zero
            }
            .subscribe(Subscribers.Assign(object: self, keyPath: \.keyboardHeight))
    }
}
