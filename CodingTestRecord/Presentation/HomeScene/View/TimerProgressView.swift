//
//  TimerProgressView.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/16.
//

import UIKit

final class TimerProgressView: UIProgressView {
    convenience init(width: CGFloat, color: UIColor = .blue) {
        self.init(frame: .zero)
        self.configureUI(width: width, color: color)
    }
}

// MARK: - Private Functions
private extension TimerProgressView {
    func configureUI(width: CGFloat, color: UIColor) {
        self.progressTintColor = color
        self.trackTintColor = .systemGray
        self.setProgress(0.5, animated: false)
        
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: width),
            self.heightAnchor.constraint(equalToConstant: 5)
        ])
    }
}
