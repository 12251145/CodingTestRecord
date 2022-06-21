//
//  CodingTestResultCellView.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/20.
//

import SwiftUI
import Charts

struct CodingTestResultCellView: View {
    var problems: [Problem]
    var title: String
    var graphWidth: CGFloat
    let width = UIScreen.main.bounds.width - 32
    let height = (UIScreen.main.bounds.width - 32) / 4
    
    init(
        codingTestResult: CodingTestResult
    ) {
        self.problems = codingTestResult.problemArr
        self.title = codingTestResult.title ?? ""
        self.graphWidth = CGFloat(self.problems.count) * 12
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 15) {
                Text(title)
                    .font(.system(.title2, weight: .bold))
                    .lineLimit(1)
            }
            
            Spacer()
            
            Chart(problems) { problem in
                RuleMark(x: .value("id", problem.id!),
                         yStart: .value("Start", -problem.difficulty),
                         yEnd: .value("End", problem.difficulty)
                )
                .foregroundStyle(self.barColor(from: problem))
                .lineStyle(.init(lineWidth: 8, lineCap: .round))
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .frame(width: graphWidth, height: 50)
        }
        .tint(.pink)
        .padding(.horizontal, 5)
        .chartYScale(domain: -5...5)
        .frame(width: width, height: height)
    }
}

private extension CodingTestResultCellView {
    func barColor(from problem: Problem) -> Color {
        
        if problem.checkEfficiency {
            if problem.passAccuracyTest && problem.passEfficiencyTest {
                return .pink
            }
            
            if problem.passAccuracyTest && !problem.passEfficiencyTest {
                return .pink.opacity(0.5)
            }
        } else {
            if problem.passAccuracyTest {
                return .pink
            }
        }
        
        return .gray
    }
}
