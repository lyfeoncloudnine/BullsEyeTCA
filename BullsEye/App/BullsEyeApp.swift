//
//  BullsEyeApp.swift
//  BullsEye
//
//  Created by lyfeoncloudnine on 2023/05/02.
//

import SwiftUI

@main
struct BullsEyeApp: App {
    var body: some Scene {
        WindowGroup {
            GameView(store: .init(initialState: GameFeature.State(), reducer: GameFeature(recordService: RecordService())))
        }
    }
}
