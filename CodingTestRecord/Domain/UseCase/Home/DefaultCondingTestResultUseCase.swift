//
//  DefaultCondigTestResultUseCase.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/18.
//

import Combine
import Foundation

final class DefaultCodingTestResultUseCase: CodingTestResultUseCase {
    private let codingTestResultRepository: CodingTestResultRepository
    var codingTestResult: CurrentValueSubject<CodingTestResult?, Never>
    var probelmEvents = CurrentValueSubject<[ProblemEvent], Never>([])
    
    init(
        codingTestResultRepository: CodingTestResultRepository,
        codingTesting: CodingTesting
    ) {
        self.codingTestResultRepository = codingTestResultRepository
        self.codingTestResult = CurrentValueSubject<CodingTestResult?, Never>(
            self.codingTestResultRepository.getCodingTestResult(by: codingTesting)
        )
        self.probelmEvents.send(
            self.getProblemEvents()
        )
    }
    
    func getScore() -> Double {
        var score: Double = 0
        
        for problem in self.codingTestResult.value?.problemArr ?? [] {
            if problem.checkEfficiency {
                score += problem.passAccuracyTest ? 0.5 : 0
                score += problem.passEfficiencyTest ? 0.5 : 0
            } else {
                score += problem.passAccuracyTest ? 1 : 0
            }
        }
        
        return score
    }
    
    func getProblemEvents() -> [ProblemEvent] {
        var arr: [ProblemEvent] = []
        
        for problem in self.codingTestResult.value?.problemArr ?? [] {
            if problem.passAccuracyTest {
                let problemEvent = ProblemEvent(
                    index: Int(problem.index),
                    difficulty: Int(problem.difficulty),
                    passKind: .accuracy,
                    passTime: Int(problem.accuracyTestPassTime),
                    takeTime: 0
                )
                
                arr.append(problemEvent)
            }
            
            if problem.passEfficiencyTest {
                let problemEvent = ProblemEvent(
                    index: Int(problem.index),
                    difficulty: Int(problem.difficulty),
                    passKind: .efficiency,
                    passTime: Int(problem.efficiencyTestPassTime),
                    takeTime: 0
                )
                
                arr.append(problemEvent)
            }
        }
        
        var sorted = arr.sorted { l, r in
            return l.passTime < r.passTime
        }
        
        for i in 0..<sorted.count {
            if i == 0 {
                sorted[i].takeTime = sorted[i].passTime
            } else {
                sorted[i].takeTime = sorted[i].passTime - sorted[i - 1].passTime
            }
        }
        
        return sorted
    }
}
