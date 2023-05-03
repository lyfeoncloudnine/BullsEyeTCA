//
//  RecordView.swift
//  BullsEye
//
//  Created by lyfeoncloudnine on 2023/05/03.
//

import SwiftUI

import ComposableArchitecture

struct RecordView: View {
    let store: StoreOf<RecordFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            List {
                Section {
                    ForEach(viewStore.records) { record in
                        HStack {
                            Text("\(record.targetNumber)")
                            Spacer()
                            Text("\(record.score)")
                        }
                    }
                    .onDelete { viewStore.send(.delete($0)) }
                } header: {
                    HStack {
                        Text("맞춘 숫자")
                        Spacer()
                        Text("점수")
                    }
                }
            }
            .navigationTitle(viewStore.title)
            .task {
                viewStore.send(.load)
            }
        }
    }
}

struct RecordView_Previews: PreviewProvider {
    static let recordService: RecordServiceType = RecordService()
    
    static var previews: some View {
        NavigationView {
            RecordView(store: .init(initialState: RecordFeature.State(), reducer: RecordFeature(recordService: recordService)))
        }
    }
}
