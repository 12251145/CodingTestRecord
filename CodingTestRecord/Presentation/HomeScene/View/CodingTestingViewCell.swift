//
//  CodingTestingViewCell.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/17.
//

import UIKit

class CodingTestingViewCell: UITableViewCell {
    private lazy var problemLabel: UILabel = {
        let label = UILabel()
        
        label.backgroundColor = .black
        label.clipsToBounds = true
        label.layer.cornerRadius = 15
        label.layer.cornerCurve = .continuous
        
        
        
        return label
    }()
    
    private lazy var checkSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = false
        
        return toggle
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CodingTestingViewCell {
    private func configureUI() {
        
        self.contentView.addSubview(self.problemLabel)
        self.problemLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.problemLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            self.problemLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.problemLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 5.5),
            self.problemLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 5.5),
        ])
        
        self.contentView.addSubview(self.checkSwitch)
        self.checkSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.checkSwitch.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.checkSwitch.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16)
        ])
    }
}
