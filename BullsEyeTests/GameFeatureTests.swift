//
//  GameFeatureTests.swift
//  BullsEyeTests
//
//  Created by lyfeoncloudnine on 2023/05/03.
//

import XCTest
import ComposableArchitecture

@testable import BullsEye

@MainActor
final class GameFeatureTests: XCTestCase {
    let recordService: RecordServiceType = RecordService()
    let randomNumber = { 1 }
    
    override func tearDown() {
        recordService.clear()
        super.tearDown()
    }
    
    func testPlayButtonTap() async {
        let store = TestStore(initialState: GameFeature.State(), reducer: GameFeature(recordService: recordService, randomNumber: randomNumber))
        
        await store.send(.playButtonTap) {
            $0.isPlaying = true
            $0.round = 1
            $0.score = 100
            $0.targetNumber = 1
            $0.expectNumber = 50
        }
    }
    
    func testChangeExpectNumber() async {
        let store = TestStore(initialState: GameFeature.State(), reducer: GameFeature(recordService: recordService, randomNumber: randomNumber))
        store.exhaustivity = .off
        
        await store.send(.playButtonTap)
        
        await store.send(.changeExpectNumber(100)) {
            $0.expectNumber = 100
        }
    }
    
    func testCheckButtonTapFail() async {
        let store = TestStore(initialState: GameFeature.State(), reducer: GameFeature(recordService: recordService, randomNumber: randomNumber))
        store.exhaustivity = .off
        
        await store.send(.playButtonTap)
        await store.send(.changeExpectNumber(2))
        await store.send(.checkButtonTap)
        
        let alertMessage = """
        😓아쉬워요😓
        정답과 차이는 1에요.
        다시 한 번 시도해 보세요!
        """
        await store.receive(.keepPlay(alertMessage)) {
            $0.round = 2
            $0.score = 99
            $0.expectNumber = 50
            $0.alertMessage = alertMessage
        }
        
        await store.send(.alertDismissed) {
            $0.alertMessage = nil
        }
    }
    
    func testCheckButtonTapSuccess() async {
        let store = TestStore(initialState: GameFeature.State(), reducer: GameFeature(recordService: recordService, randomNumber: randomNumber))
        store.exhaustivity = .off
        
        await store.send(.playButtonTap)
        await store.send(.changeExpectNumber(1))
        await store.send(.checkButtonTap)
        
        let alertMessage = """
        🎊축하합니다!🎊
        1회만에 정답을 맞히셨네요!
        점수는 100점이에요!
        """
        await store.receive(.finish(alertMessage)) {
            $0.isPlaying = false
            $0.alertMessage = alertMessage
        }
        
        await store.send(.alertDismissed) {
            $0.alertMessage = nil
        }
    }
    
    func testNavigation() async {
        let store = TestStore(initialState: GameFeature.State(), reducer: GameFeature(recordService: recordService, randomNumber: randomNumber))
        
        await store.send(.setNavigation(isActive: true)) {
            $0.isNavigationActive = true
            $0.recordState = RecordFeature.State()
        }
        
        await store.send(.setNavigation(isActive: false)) {
            $0.isNavigationActive = false
            $0.recordState = nil
        }
    }
}
