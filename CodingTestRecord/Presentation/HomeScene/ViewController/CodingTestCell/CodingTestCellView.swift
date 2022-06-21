//
//  CodingTestCellView.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/14.
//

import SwiftUI
import Charts

struct CodingTestCellView: View {    
    var problems: [Problem]
    var title: String
    var timeLimit: Int
    var graphWidth: CGFloat
    let width = UIScreen.main.bounds.width - 32
    let height = (UIScreen.main.bounds.width - 32) / 4
    
    init(setting: CodingTestSetting) {
        self.title = setting.title ?? ""
        self.timeLimit = Int(setting.timeLimit)
        self.problems = setting.problemArr
        self.graphWidth = CGFloat(self.problems.count) * 12
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 15) {
                Text(title)
                    .font(.system(.title, weight: .semibold))
                    .lineLimit(1)                
                    
                    
                
                CodingTestLimitTimeView(time: Int(timeLimit))
            }
            
            Spacer()
            
            Chart(problems) { problem in
                RuleMark(x: .value("id", problem.id!),
                         yStart: .value("Start", -problem.difficulty),
                         yEnd: .value("End", problem.difficulty)
                )
                .foregroundStyle(.pink)
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

struct CodingTestLimitTimeView: View {
    var time: Int
    var m: Int
    var h: Int
    
    init(time: Int) {
        self.time = time
        self.m = self.time / 60 % 60
        self.h = self.time / 3600
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Text("\(h)")
                .font(.system(.title2, weight: .semibold))
            Text("시간")
                .font(.system(.title3, weight: .bold))
                .foregroundColor(.secondary)
            
            Text(" ")
            
            if m != 0 {
                Text("\(m)")
                    .font(.system(.title2, weight: .semibold))
                Text("분")
                    .font(.system(.title3, weight: .bold))
                    .foregroundColor(.secondary)
            }
        }
    }
}
