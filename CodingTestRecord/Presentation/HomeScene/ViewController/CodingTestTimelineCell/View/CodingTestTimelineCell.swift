//
//  CodingTestTimelineCell.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/18.
//

import Combine
import UIKit

final class CodingTestTimelineCell: UITableViewCell {
    var viewModel: CodingTestTimelineCellViewModel?
    var subscriptions = Set<AnyCancellable>()
    
    private lazy var badgeTimeVStack: UIStackView = {
        let stack = UIStackView()
        
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        
        return stack
    }()
    
    private lazy var problemEventHStack: UIStackView = {
        let stack = UIStackView()
        
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        
        return stack
    }()
    
    private lazy var problemIndexBadge: UILabel = {
        let label = UILabel()
        
        label.backgroundColor = .secondarySystemBackground
        label.clipsToBounds = true
        label.layer.cornerRadius = 15
        label.text = "1"
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var problemDifficultyBadge: UILabel = {
        let label = UILabel()
        
        label.backgroundColor = .black
        label.clipsToBounds = true
        label.layer.cornerRadius = 15
        label.text = "1"
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .systemPink
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var problemAccuracyPassKindBadge: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "checkmark.seal.fill")
        
        imageView.tintColor = .systemGreen
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private lazy var problemEfficiencyPassKindBadge: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "bolt.square.fill")
        
        imageView.tintColor = .systemGreen
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        
        label.text = "00:32:17"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var takeTimeLabel: UILabel = {
        let label = UILabel()
        
        label.text = "32분"
        label.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var devider: UIView = {
        let rect = UIView()
        
        rect.backgroundColor = .secondarySystemBackground
        
        return rect
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        self.bindViewModel()
    }
}

private extension CodingTestTimelineCell {
    func configureUI() {
        self.contentView.addSubview(self.problemEventHStack)
        self.problemEventHStack.addArrangedSubview(self.problemIndexBadge)
        self.problemEventHStack.addArrangedSubview(self.problemDifficultyBadge)
        self.problemEventHStack.addArrangedSubview(self.problemAccuracyPassKindBadge)
        self.problemEventHStack.addArrangedSubview(self.problemEfficiencyPassKindBadge)
        self.problemEventHStack.translatesAutoresizingMaskIntoConstraints = false
        self.problemIndexBadge.translatesAutoresizingMaskIntoConstraints = false
        self.problemDifficultyBadge.translatesAutoresizingMaskIntoConstraints = false
        self.problemAccuracyPassKindBadge.translatesAutoresizingMaskIntoConstraints = false
        self.problemEfficiencyPassKindBadge.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(self.badgeTimeVStack)
        self.badgeTimeVStack.addArrangedSubview(self.problemEventHStack)
        self.badgeTimeVStack.addArrangedSubview(self.timeLabel)
        self.badgeTimeVStack.translatesAutoresizingMaskIntoConstraints = false
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.badgeTimeVStack.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.badgeTimeVStack.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            self.badgeTimeVStack.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width / 5.5) + 8),
            
            self.problemEventHStack.widthAnchor.constraint(equalToConstant: 120),
            
            self.problemIndexBadge.widthAnchor.constraint(equalToConstant: 30),
            self.problemIndexBadge.heightAnchor.constraint(equalToConstant: 30),
            
            self.problemDifficultyBadge.widthAnchor.constraint(equalToConstant: 30),
            self.problemDifficultyBadge.heightAnchor.constraint(equalToConstant: 30),
            
            self.problemAccuracyPassKindBadge.widthAnchor.constraint(equalToConstant: 36),
            self.problemAccuracyPassKindBadge.heightAnchor.constraint(equalToConstant: 36),
            
            self.problemEfficiencyPassKindBadge.widthAnchor.constraint(equalToConstant: 33),
            self.problemEfficiencyPassKindBadge.heightAnchor.constraint(equalToConstant: 33),
        ])
        
        self.contentView.addSubview(self.devider)
        self.devider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.devider.centerYAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.devider.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            self.devider.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            self.devider.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        self.contentView.addSubview(self.takeTimeLabel)
        self.takeTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.takeTimeLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
            self.takeTimeLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
    
    func bindViewModel() {
        let output = self.viewModel?.transform(
            from: CodingTestTimelineCellViewModel.Input(),
            subscriptions: &subscriptions
        )
        
        output?.passTime
            .sink(receiveValue: { [weak self] passTime in
                self?.timeLabel.text = passTime
            })
            .store(in: &subscriptions)
        
        output?.takeTime
            .sink(receiveValue: { [weak self] takeTime in
                self?.takeTimeLabel.text = takeTime
            })
            .store(in: &subscriptions)
        
        output?.index
            .sink(receiveValue: { [weak self] index in
                self?.problemIndexBadge.text = index
            })
            .store(in: &subscriptions)
        
        output?.difficulty
            .sink(receiveValue: { [weak self] difficulty in
                self?.problemDifficultyBadge.text = difficulty
            })
            .store(in: &subscriptions)
        
        output?.passKind
            .sink(receiveValue: { [weak self] passKind in
                if passKind == .accuracy {
                    self?.problemEfficiencyPassKindBadge.removeFromSuperview()
                } else if passKind == .efficiency {
                    self?.problemAccuracyPassKindBadge.removeFromSuperview()
                }
            })
            .store(in: &subscriptions)
    }
}
