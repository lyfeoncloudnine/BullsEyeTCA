//
//  GameFeature.swift
//  BullsEye
//
//  Created by lyfeoncloudnine on 2023/05/02.
//

import Foundation

import ComposableArchitecture

struct GameFeature: ReducerProtocol {
    struct State: Equatable {}
    
    enum Action: Equatable {}
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        
    }
}
