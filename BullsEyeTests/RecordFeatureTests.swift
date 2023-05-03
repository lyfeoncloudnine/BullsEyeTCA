//
//  RecordFeatureTests.swift
//  BullsEyeTests
//
//  Created by lyfeoncloudnine on 2023/05/03.
//

import XCTest
import ComposableArchitecture

@testable import BullsEye

@MainActor
final class RecordFeatureTests: XCTestCase {
    let recordService: RecordServiceType = RecordService()
    let record = Record(targetNumber: 1, score: 99)
    
    override func setUp() {
        super.setUp()
        
        recordService.create(record: record)
    }
    
    override func tearDown() {
        recordService.clear()
        super.tearDown()
    }
    
    func testLoad() async {
        let store = TestStore(initialState: RecordFeature.State(), reducer: RecordFeature(recordService: recordService))
        store.exhaustivity = .off
        
        await store.send(.load)
        
        await store.receive(.setRecords([self.record])) {
            $0.records = [self.record]
        }
    }
    
    func testDelete() async {
        let store = TestStore(initialState: RecordFeature.State(), reducer: RecordFeature(recordService: recordService))
        store.exhaustivity = .off
        
        await store.send(.load)
        await store.send(.delete(record))
        
        await store.receive(.setRecords([])) {
            $0.records = []
        }
    }
}
