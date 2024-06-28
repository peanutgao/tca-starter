//
//  StarterTCAApp.swift
//  StarterTCA
//
//  Created by Joseph Koh on 2024/6/28.
//

import SwiftUI
import ComposableArchitecture

@main
struct StarterTCAApp: App {
    
    static let store = Store(initialState: CounterFeature.State(), reducer: {
        CounterFeature()
            ._printChanges()    // 日志打印，可以打印state改变的前、后的值
    })
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: StarterTCAApp.store
            )
        }
    }
}
