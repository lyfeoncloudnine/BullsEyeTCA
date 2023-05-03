//
//  GameFeature.swift
//  BullsEye
//
//  Created by lyfeoncloudnine on 2023/05/02.
//

import Foundation

import ComposableArchitecture

struct GameFeature: ReducerProtocol {
    enum Action: Equatable {
        case playButtonTap
        case changeExpectNumber(Float)
        case checkButtonTap
        case keepPlay(String)
        case finish(String)
        case alertDismissed
    }
    
    struct State: Equatable {
        var isPlaying = false
        var round = 1
        var score = 100
        var targetNumber: Int?
        var expectNumber: Float = 50
        var title = "BullsEye 🎯"
        var alertMessage: String?
    }
    
    let recordService: RecordServiceType
    let randomNumber: (() -> Int)
    
    init(recordService: RecordServiceType, randomNumber: @escaping (() -> Int) = { Int.random(in: 1...100) }) {
        self.recordService = recordService
        self.randomNumber = randomNumber
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .playButtonTap:
            state.isPlaying = true
            state.round = 1
            state.score = 100
            state.targetNumber = randomNumber()
            state.expectNumber = 50
            return .none
            
        case .changeExpectNumber(let expectNumber):
            state.expectNumber = expectNumber
            return .none
            
        case .checkButtonTap:
            guard let targetNumber = state.targetNumber else { return .none }
            let expectNumber = Int(state.expectNumber.rounded())
            
            if targetNumber == expectNumber {
                recordService.create(record: Record(targetNumber: targetNumber, score: state.score))
                let alertMessage = """
                🎊축하합니다!🎊
                \(state.round)회만에 정답을 맞히셨네요!
                점수는 \(state.score)점이에요!
                """
                return .send(.finish(alertMessage))
            } else {
                let diff = abs(targetNumber - expectNumber)
                let alertMessage = """
                😓아쉬워요😓
                정답과 차이는 \(diff)에요.
                다시 한 번 시도해 보세요!
                """
                return .send(.keepPlay(alertMessage))
            }
            
        case .keepPlay(let alertMessage):
            state.round += 1
            state.score -= 1
            state.expectNumber = 50
            state.alertMessage = alertMessage
            return .none
            
        case .finish(let alertMessage):
            state.isPlaying = false
            state.alertMessage = alertMessage
            return .none
            
        case .alertDismissed:
            state.alertMessage = nil
            return .none
        }
    }
}
