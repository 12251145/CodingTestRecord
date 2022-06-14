//
//  RecordsViewModel.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/13.
//

import Foundation

final class RecordsViewModel {
    weak var coordinator: RecordsCoordinator?
    private var recordsUseCase: RecordsUseCase
    
    init(coordinator: RecordsCoordinator, recordsUseCase: RecordsUseCase) {
        self.coordinator = coordinator
        self.recordsUseCase = recordsUseCase
    }
}
