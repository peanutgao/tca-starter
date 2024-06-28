//
//  ContentView.swift
//  StarterTCA
//
//  Created by Joseph Koh on 2024/6/28.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    // 以为使用 ObservableState() 宏自动观察存储中的数据，所以可以直接用let
    let store: StoreOf<CounterFeature>
    
    var body: some View {
        VStack {
            Text("\(store.count)")
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .clipShape(.rect(cornerRadius: 10))
            
            HStack {
                actionButton("-") {
                    store.send(.decrementButtonTapped)
                }
                
                actionButton("+"){
                    store.send(.incrementButtonTapped)
                }
            }
                        
            actionButton("Fact") {
                store.send(.factButtonTapped)
            }
            
            if store.isLoading {
                ProgressView()
            } else if let fact = store.fact {
                Text(fact)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
    }
    
    func actionButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(title, action: action)
        .font(.largeTitle)
        .padding()
        .background(.black.opacity(0.1))
        .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    ContentView(
        store: Store(initialState: CounterFeature.State(), reducer: {
            CounterFeature()
        })
    )
}
