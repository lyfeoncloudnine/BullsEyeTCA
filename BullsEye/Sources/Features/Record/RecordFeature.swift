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
        
    }
    
    struct State: Equatable {
        
    }
    
    let recordService: RecordServiceType
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        
    }
}
