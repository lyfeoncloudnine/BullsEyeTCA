//
//  RecordFeature.swift
//  BullsEye
//
//  Created by lyfeoncloudnine on 2023/05/03.
//

import Foundation

import ComposableArchitecture

struct RecordFeature: ReducerProtocol {
    enum Action: Equatable {
        case load
        case delete(IndexSet)
        case setRecords([Record])
    }
    
    struct State: Equatable {
        var records = [Record]()
        var title = "명예의 전당"
    }
    
    let recordService: RecordServiceType
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .load:
            let records = recordService.records()
            return .send(.setRecords(records))
            
        case .delete(let index):
            let records = recordService.delete(index: index)
            return .send(.setRecords(records))
            
        case .setRecords(let records):
            state.records = records
            return  .none
        }
    }
}
