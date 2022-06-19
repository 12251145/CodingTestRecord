//
//  CodingTestingViewCell.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/17.
//

import Combine
import UIKit

class CodingTestingViewCell: UITableViewCell {
    var viewModel: CodingTestingCellViewModel?
    var subscriptions = Set<AnyCancellable>()
    
    private lazy var problemLabel: UILabel = {
        let label = UILabel()
        
        label.backgroundColor = .black
        label.clipsToBounds = true
        label.layer.cornerRadius = 18
        label.layer.cornerCurve = .continuous
        label.text = "1"
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .systemPink
        label.textAlignment = .center
        
        
        return label
    }()
    
    private lazy var accuracyPassSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = false
        
        return toggle
    }()
    
    private lazy var efficiencyPassSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = false
        
        return toggle
    }()
    
    private lazy var devider: UIView = {
        let rect = UIView()
        
        rect.backgroundColor = .systemGray5
        
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

private extension CodingTestingViewCell {
    func configureUI() {        
        self.contentView.addSubview(self.problemLabel)
        self.problemLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.problemLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            self.problemLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.problemLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 5.5),
            self.problemLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 5.5),
        ])
        
        self.contentView.addSubview(self.accuracyPassSwitch)
        self.accuracyPassSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.accuracyPassSwitch.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.accuracyPassSwitch.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16)
        ])
        
        self.contentView.addSubview(self.efficiencyPassSwitch)
        self.efficiencyPassSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.efficiencyPassSwitch.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.efficiencyPassSwitch.rightAnchor.constraint(equalTo: self.accuracyPassSwitch.leftAnchor, constant: -16)
        ])
        
        self.contentView.addSubview(self.devider)
        self.devider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.devider.centerYAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.devider.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            self.devider.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            self.devider.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    func bindViewModel() {        
        let output = self.viewModel?.transform(
            from: CodingTestingCellViewModel.Input(
                passAccuracySwitchEvent: self.accuracyPassSwitch.controlPublisher(for: .valueChanged).eraseToAnyPublisher(),
                passEfficiencySwitchEvent: self.efficiencyPassSwitch.controlPublisher(for: .valueChanged).eraseToAnyPublisher()
            ),
            subscruptions: &subscriptions
        )
        
        output?.currentDifficulty
            .sink(receiveValue: { [weak self] difficulty in
                self?.problemLabel.text = "\(difficulty)"
            })
            .store(in: &subscriptions)
        
        output?.showEfficiencySwitch
            .sink(receiveValue: { [weak self] showSwitch in
                if !showSwitch {
                    self?.efficiencyPassSwitch.removeFromSuperview()
                }
            })
            .store(in: &subscriptions)
    }
}
