//
//  ProblemSettingSheetViewController.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/17.
//

import Combine
import UIKit

class ProblemSettingSheetViewController: UIViewController {
    var viewModel: ProblemSettingSheetViewModel?    
    var problem: Problem?
    var subscriptions = Set<AnyCancellable>()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .large
        config.title = "저장"
        config.baseForegroundColor = .systemPink
        config.baseBackgroundColor = .secondarySystemBackground
        
        button.configuration = config
        
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .large
        config.title = "삭제"
        config.baseForegroundColor = .secondarySystemBackground
        config.baseBackgroundColor = .systemPink
        
        button.configuration = config
        
        return button
    }()
    
    private lazy var efficiencyHStack: UIStackView = {
        let stack = UIStackView()
        
        stack.distribution = .equalSpacing
        stack.axis = .horizontal
        
        return stack
    }()
    
    private lazy var checkEfficiencyLabel: UILabel = {
        let label = UILabel()
        
        label.text = "효율성 체크"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        return label
    }()
    
    private lazy var checkSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = false
        
        return toggle
    }()
    
    private lazy var currentDifficultyLabel: UILabel = {
        
        let label = UILabel()
        
        label.backgroundColor = .black
        label.clipsToBounds = true
        label.layer.cornerRadius = 18
        label.layer.cornerCurve = .continuous
        label.text = "\(problem!.difficulty)"
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .systemPink
        label.textAlignment = .center
        
        
        return label
    }()
    
    private lazy var upDownButtonsHStack: UIStackView = {
        var stack = UIStackView()
        
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        
        return stack
    }()
    
    private lazy var difficultyUpButton: UIButton = {
        var button = UIButton()
        var config = UIButton.Configuration.filled()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .small)
        
        config.image = UIImage(systemName: "plus", withConfiguration: imageConfig)
        config.baseForegroundColor = .black
        config.baseBackgroundColor = .secondarySystemBackground
        config.cornerStyle = .capsule
        
        button.configuration = config
        
        return button
    }()
    
    private lazy var difficultyDownButton: UIButton = {
        var button = UIButton()
        var config = UIButton.Configuration.filled()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .small)
        
        config.image = UIImage(systemName: "minus", withConfiguration: imageConfig)
        config.baseForegroundColor = .black
        config.baseBackgroundColor = .secondarySystemBackground
        config.cornerStyle = .capsule
        
        button.configuration = config
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.viewModel?.delegate?.reloadTableView()
    }
}

private extension ProblemSettingSheetViewController {
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(self.saveButton)
        self.saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.saveButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            self.saveButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12)
        ])
        
        view.addSubview(self.deleteButton)
        self.deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.deleteButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            self.deleteButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12)
        ])
        
        let firstDevider = createDevider()
        view.addSubview(firstDevider)
        firstDevider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            firstDevider.topAnchor.constraint(equalTo: self.saveButton.bottomAnchor, constant: 12),
            firstDevider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstDevider.widthAnchor.constraint(equalTo: view.widthAnchor),
            firstDevider.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        view.addSubview(self.efficiencyHStack)
        self.efficiencyHStack.translatesAutoresizingMaskIntoConstraints = false
        self.checkEfficiencyLabel.translatesAutoresizingMaskIntoConstraints = false
        self.checkSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        self.efficiencyHStack.addArrangedSubview(self.checkEfficiencyLabel)
        self.efficiencyHStack.addArrangedSubview(self.checkSwitch)
        
        NSLayoutConstraint.activate([
            self.efficiencyHStack.topAnchor.constraint(equalTo: firstDevider.bottomAnchor, constant: 12),
            self.efficiencyHStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.efficiencyHStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            self.efficiencyHStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
        ])
        
        let secondDevider = createDevider()
        view.addSubview(secondDevider)
        secondDevider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            secondDevider.topAnchor.constraint(equalTo: self.efficiencyHStack.bottomAnchor, constant: 12),
            secondDevider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondDevider.widthAnchor.constraint(equalTo: view.widthAnchor),
            secondDevider.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        view.addSubview(self.currentDifficultyLabel)
        self.currentDifficultyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(self.upDownButtonsHStack)
        self.upDownButtonsHStack.translatesAutoresizingMaskIntoConstraints = false
        self.difficultyUpButton.translatesAutoresizingMaskIntoConstraints = false
        self.difficultyDownButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.upDownButtonsHStack.addArrangedSubview(self.difficultyDownButton)
        self.upDownButtonsHStack.addArrangedSubview(self.difficultyUpButton)
        
        NSLayoutConstraint.activate([
            self.currentDifficultyLabel.topAnchor.constraint(equalTo: secondDevider.bottomAnchor, constant: 20),
            self.currentDifficultyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.currentDifficultyLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            self.currentDifficultyLabel.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            
            self.upDownButtonsHStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.upDownButtonsHStack.centerYAnchor.constraint(equalTo: self.currentDifficultyLabel.centerYAnchor),
            self.upDownButtonsHStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 60),
            self.upDownButtonsHStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -60),
        ])
    }
    
    func bindViewModel() {
        let output = self.viewModel?.transform(from: ProblemSettingSheetViewModel.Input(
            switchEvent: self.checkSwitch.controlPublisher(for: .valueChanged).eraseToAnyPublisher(),
            difficultyUpButtonDidTap: self.difficultyUpButton.publisher(for: .touchUpInside).eraseToAnyPublisher(),
            difficultyDownButtonDidTap: self.difficultyDownButton.publisher(for: .touchUpInside).eraseToAnyPublisher(),
            saveButtonDidTap: self.saveButton.publisher(for: .touchUpInside).eraseToAnyPublisher(),
            deleteButtonDidTap: self.deleteButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
        ),
                                  subscriptions: &subscriptions
        )
        
        output?.currentDifficulty
            .map { String($0) }
            .sink(receiveValue: { [weak self] newValue in
                self?.currentDifficultyLabel.text = newValue
            })
            .store(in: &subscriptions)
        
        output?.checkEfficiency
            .sink(receiveValue: { [weak self] isOn in
                self?.checkSwitch.isOn = isOn
            })
            .store(in: &subscriptions)
        
        output?.shouldDismiss
            .filter { $0 }
            .sink(receiveValue: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .store(in: &subscriptions)
    }
    
    func createDevider() -> UIView {
        let rect = UIView()
        
        rect.backgroundColor = .secondarySystemBackground
        
        return rect
    }
}
