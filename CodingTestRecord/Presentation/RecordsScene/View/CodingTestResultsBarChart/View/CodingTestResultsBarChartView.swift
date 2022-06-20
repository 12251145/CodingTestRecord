//
//  CodingTestResultsBarChartView.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/19.
//

import Charts
import Combine
import SwiftUI

struct CodingTestResultsBarChartView: View {
    var chartData: ChartData
    
    init(
        chartData: ChartData
    ) {
        self.chartData = chartData        
    }
    
    var body: some View {
        VStack(alignment: .center) {
            
            HStack {
                Text("요약")
                    .font(.system(size: 25, weight: .semibold))
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            
            Spacer()
            
                
            Chart(chartData.series) { series in
                ForEach(series.count) { element in
                    BarMark(
                        x: .value("index", element.index),
                        y: .value("count", element.count)
                    )
                    .foregroundStyle(by: .value("Type", series.type))
                }
                
                RuleMark(
                    y: .value("해결 평균", chartData.correctAvg)
                )
                .foregroundStyle(.pink.opacity(0.5))
                .annotation(position: .leading) {
                    Text(chartData.correctAvg.oneFraction)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.pink)
                }
                
                
                RuleMark(
                    y: .value("문제 평균", chartData.problemCountAvg)
                )
                .foregroundStyle(.gray.opacity(0.5))
                .annotation(position: .trailing) {
                    Text(chartData.problemCountAvg.oneFraction)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                }
                
            }
            .chartForegroundStyleScale([
                "해결": .pink,
                "틀림": .gray
            ])
            .chartYAxis(.hidden)
            .chartXAxis(.hidden)
            .frame(width: UIScreen.main.bounds.width - 96, height: UIScreen.main.bounds.width * 0.5 / 1.7)
            .padding(.bottom, 12)
            
            
        }
        .frame(width: UIScreen.main.bounds.width - 32, height: UIScreen.main.bounds.width * 0.5)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(uiColor: .secondarySystemBackground))
        )
    }
}


