//
//  ProblemsSettingViewController.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/15.
//

import Combine
import SwiftUI
import UIKit

final class ProblemsSettingViewController: UIViewController {
    var viewModel: ProblemsSettingViewModel?
    var subscriptions = Set<AnyCancellable>()
    var deleteButtonDidTap = PassthroughSubject<Int, Never>()
    
    private lazy var noticeLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.text = "문제를 추가하고 설정해보세요."
        
        return label
    }()
    
    private lazy var addProblemButton: UIButton = {
        var button = UIButton()
        var config = UIButton.Configuration.filled()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 35, weight: .semibold, scale: .small)
        
        config.image = UIImage(systemName: "plus", withConfiguration: imageConfig)
        config.baseForegroundColor = .systemPink
        config.baseBackgroundColor = .secondarySystemBackground
        config.cornerStyle = .capsule
        
        button.configuration = config
        
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 0.5
        button.layer.shadowColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        return button
    }()
    
    private lazy var devider: UIView = {
        let rect = UIView()
        
        rect.backgroundColor = .secondarySystemBackground
        
        return rect
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .singleLine
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProblemTableViewCell.self, forCellReuseIdentifier: "ProblemTableViewCell")
        
        return tableView
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .large
        config.title = "다음"
        
        button.configuration = config
        
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowOpacity = 0.8
        button.layer.shadowColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        return button
    }()
    
    override func viewDidLoad() {        
        super.viewDidLoad()
        
        configureUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
}

// MARK: - Private Functions
private extension ProblemsSettingViewController {
    func configureUI() {
        view.backgroundColor = .white
        self.navigationItem.title = "문제 설정"
        
        self.view.addSubview(self.noticeLabel)
        self.noticeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.noticeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height / 6),
            self.noticeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        self.view.addSubview(self.addProblemButton)
        self.addProblemButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.addProblemButton.topAnchor.constraint(equalTo: self.noticeLabel.bottomAnchor, constant: 50),
            self.addProblemButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.addProblemButton.bottomAnchor, constant: 55),
            self.tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        self.view.addSubview(self.devider)
        self.devider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.devider.topAnchor.constraint(equalTo: self.tableView.topAnchor),
            self.devider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.devider.widthAnchor.constraint(equalTo: view.widthAnchor),
            self.devider.heightAnchor.constraint(equalToConstant: 2)
        ])
        
        self.view.addSubview(self.nextButton)
        self.nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            self.nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            self.nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            self.nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func bindViewModel() {
        let output = viewModel?.transform(
            from: ProblemsSettingViewModel.Input(
                deleteButtonDidTap: self.deleteButtonDidTap.eraseToAnyPublisher(),
                viewDidLoadEvent: Just(()).eraseToAnyPublisher(),
                addProblemButtonDidTap: self.addProblemButton.publisher(for: .touchUpInside).eraseToAnyPublisher(),
                nextButtonDidTap: self.nextButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
            ),
            subscriptions: &subscriptions
        )
        
        output?.addButtonDidTap
            .filter { $0 }
            .sink(receiveValue: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .store(in: &subscriptions)
    }
}


extension ProblemsSettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (UIScreen.main.bounds.width / 5.5) + 32
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.problems.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProblemTableViewCell") as! ProblemTableViewCell
        let problem = self.viewModel?.problems[indexPath.row]
        
        cell.contentConfiguration = UIHostingConfiguration {
            
            HStack(spacing: 15) {
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 17, style: .continuous)
                        .fill(.black)
                        .frame(width: UIScreen.main.bounds.width / 5.5, height: UIScreen.main.bounds.width / 5.5)
                    
                    Text("\(problem?.difficulty ?? 0)")
                        .font(.system(size: 30, weight: .regular))
                        .foregroundColor(.pink)
                        
                }
                .padding(0)
                
                Spacer()
                
                HStack(spacing: 25) {
                    if problem?.checkEfficiency ?? false {
                        Image(systemName: "bolt.horizontal.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                            .foregroundColor(.green)
                    }
                        
                    
                    Image(systemName: "checkmark.seal.fill")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .foregroundColor(.green)
                }
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let problem = self.viewModel?.problems[indexPath.row] {
            
            let problemSettingSheetViewController = ProblemSettingSheetViewController()
            problemSettingSheetViewController.viewModel = ProblemSettingSheetViewModel(
                delegate: self,
                problemSettingSheetUseCase: DefaultProblemSettingSheetUseCase(
                    index: indexPath.row,
                    currentDifficulty: Int(problem.difficulty),
                    checkEfficiency: problem.checkEfficiency
                )
            )
            problemSettingSheetViewController.problem = self.viewModel?.problems[indexPath.row]
            
            if let sheet = problemSettingSheetViewController.sheetPresentationController {
                sheet.detents = [.custom(resolver: { context in
                    0.35 * context.maximumDetentValue
                })]
                sheet.prefersGrabberVisible = true
            }
            
            present(problemSettingSheetViewController, animated: true)
        }
    }
}

extension ProblemsSettingViewController: ProblemSettingSheetDelegate {
    func updateProblemSetting(difficulty: Int32, checkEfficiency: Bool, index: Int) {
        self.viewModel?.problems[index].difficulty = difficulty
        self.viewModel?.problems[index].checkEfficiency = checkEfficiency
        self.tableView.reloadData()
    }
    
    func deleteProblem(index: Int) {
        self.deleteButtonDidTap.send(index)
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
}
