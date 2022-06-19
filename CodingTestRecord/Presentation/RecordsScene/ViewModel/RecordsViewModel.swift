//
//  RecordsViewModel.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/13.
//

import Combine
import Foundation

final class RecordsViewModel {
    weak var coordinator: RecordsCoordinator?
    private var recordsUseCase: RecordsUseCase
    
    init(coordinator: RecordsCoordinator, recordsUseCase: RecordsUseCase) {
        self.coordinator = coordinator
        self.recordsUseCase = recordsUseCase
    }
    
    struct Input {
        var viewWillAppearEvent: AnyPublisher<Void, Never>
    }
    
    struct Output {        
        var chartData = CurrentValueSubject<ChartData, Never>(ChartData(series: [], correctAvg: 0, problemCountAvg: 0))
    }
    
    func transform(from input: Input, subscriptions: inout Set<AnyCancellable>) -> Output {
        let output = Output()
        
        input.viewWillAppearEvent
            .sink { [weak self] _ in
                self?.recordsUseCase.loadCodingTestResults()
            }
            .store(in: &subscriptions)
        
        self.recordsUseCase.codingTestResults
            .sink { [weak self] codingTestResults in
                
                output.chartData.send(
                    self?.getChartDate(
                        from: codingTestResults.sorted { l, r in
                            return l.date! < r.date!
                        }
                    ) ?? ChartData(series: [], correctAvg: 0, problemCountAvg: 0)
                )
            }
            .store(in: &subscriptions)
        
        return output
    }
    
    func getChartDate(from results: [CodingTestResult]) -> ChartData {
        
        var correctCounts: [CountSummary] = []
        var wrontCounts: [CountSummary] = []
        var correctCount: Double = 0
        var problemCount: Double = 0
        
        for (i, result) in results.enumerated() {
            var correctSummary = CountSummary(index: i, count: 0)
            var wrongSummary = CountSummary(index: i, count: 0)
                        
            
            for problem in result.problemArr {
                if problem.checkEfficiency {
                    if problem.passAccuracyTest {
                        correctSummary.count += 0.5
                        correctCount += 0.5
                    } else {
                        wrongSummary.count += 0.5
                    }
                    if problem.passEfficiencyTest {
                        correctSummary.count += 0.5
                    } else {
                        wrongSummary.count += 0.5
                    }
                    
                } else {
                    if problem.passAccuracyTest {
                        correctSummary.count += 1
                        correctCount += 1
                    } else {
                        wrongSummary.count += 1
                    }
                }
                
                problemCount += 1
            }
            
            correctCounts.append(correctSummary)
            wrontCounts.append(wrongSummary)
        }
        
        let seriesData: [Series] = [
            .init(type: "해결", count: correctCounts, id: "correct"),
            .init(type: "틀림", count: wrontCounts, id: "wrong")
        ]
        
        let chartData = ChartData(
            series: seriesData,
            correctAvg: correctCount / Double(results.count),
            problemCountAvg: problemCount / Double(results.count)
        )
        
        return chartData
    }
}
