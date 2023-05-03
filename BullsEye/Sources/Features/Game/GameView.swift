//
//  GameView.swift
//  BullsEye
//
//  Created by lyfeoncloudnine on 2023/05/03.
//

import SwiftUI

import ComposableArchitecture

struct GameView: View {
    let store: StoreOf<GameFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                VStack {
                    HStack {
                        Text("Round : \(viewStore.round)")
                            .font(.body)
                        Spacer()
                    }
                    
                    Spacer()
                    
                    Text("내가 맞춰야 할 점수는")
                        .font(.body)
                    
                    targetNumberView(viewStore.targetNumber)
                        .font(.largeTitle)
                    
                    Slider(
                        value: viewStore.binding(
                            get: \.expectNumber,
                            send: GameFeature.Action.changeExpectNumber
                        ),
                        in: 1...100) {
                            Text("Expect Number Slider")
                        } minimumValueLabel: {
                            Text("1")
                        } maximumValueLabel: {
                            Text("100")
                        }
                        .disabled(!viewStore.isPlaying)
                    
                    Spacer()
                    
                    Button("내 감각 체크해보기") { viewStore.send(.checkButtonTap) }
                        .disabled(!viewStore.isPlaying)
                    
                    Spacer()
                }
                .padding()
                .navigationTitle(viewStore.title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            viewStore.send(.playButtonTap)
                        } label: {
                            Image(systemName: "play.fill")
                        }
                        .disabled(viewStore.isPlaying)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            
                        } label: {
                            Image(systemName: "trophy.fill")
                        }
                    }
                }
                .alert(
                    item: viewStore.binding(
                        get: { $0.alertMessage.map(GameAlert.init(title:)) },
                        send: .alertDismissed),
                    content: { Alert(title: Text($0.title)) }
                )
            }
        }
    }
}

private extension GameView {
    func targetNumberView(_ targetNumber: Int?) -> some View {
        if let targetNumber {
            return Text("\(targetNumber)")
        } else {
            return Text("??")
        }
    }
}

struct GameAlert: Identifiable {
    var title: String
    var id: String { title }
}

struct GameView_Previews: PreviewProvider {
    static let recordService = RecordService()
    
    static var previews: some View {
        GameView(store: .init(initialState: GameFeature.State(), reducer: GameFeature(recordService: recordService)))
    }
}
