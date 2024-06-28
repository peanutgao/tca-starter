//
//  CounterFeature.swift
//  StarterTCA
//
//  Created by Joseph Koh on 2024/6/28.
//

import Foundation
// 导入框架
import ComposableArchitecture

/**
 Reducer 是 TCA 的核心组件之一。
 1. 它负责接收当前的状态和动作，并生成新的状态，同时可以返回副作用（effects）。
 2. 每当状态需要更新时，Reducer 会被调用，并根据传入的动作来决定如何修改状态。
 */

@Reducer
struct CounterFeature {
    // 1️⃣状态是应用的当前数据和UI状态。它**通常是一个简单的结构体或枚举**。
    // 创建一个 State 类型来保存您的功能完成其工作所需的状态，通常是一个 结构体
    // 如果SwiftUI要观察您的功能（通常情况下），您必须使用 ObservableState() 宏注释其状态。
    // 它是可组合架构的 @Observable 版本，但调整为值类型
    @ObservableState
    struct State {
        var count = 0
        
        var fact: String?
        var isLoading = false
    }
    
    // ✅Action 动作是描述应用状态变化的枚举。每一个动作代表用户或系统触发的一个事件。
    enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
        case factButtonTapped
        
        case factResponse(String)
    }
    
    /**
     ✅ body 是 Reducer 的一个属性，它定义了如何处理状态变化和动作。
     具体来说，body 返回一个 Reducer，这个 Reducer 包含了处理状态和动作的逻辑。
     
     */
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                state.fact = nil
                // 返回一个值 Effect（副作用） ，表示要在外部世界执行的效果，如果不需要可以返回 none
                return .none
                
            case .factButtonTapped:
                state.fact = nil
                state.isLoading = true
                
                //  ✅ 主要通过静态方法 run(priority:operation:catch:fileID:line:) 构造 Effect（副作用）
                // `Effect` 类型来描述这些异步任务，并将它们与缩减器中的动作关联
                return .run { [count = state.count] send in
                    //Do async work in here, and send actions back into the system.
                    let url = URL(string: "http://numbersapi.com/\(count)")!
                    let (data, _) = try await URLSession.shared.data(from: url)
                    let fact = String(decoding: data, as: UTF8.self)
                    
                    // send执行action
                    await send(.factResponse(fact))
                    
                }
            case .factResponse(let fact):
                state.fact = fact
                state.isLoading = false
                return .none
                
            case .incrementButtonTapped:
                state.count += 1
                state.fact = nil
                return .none
                
           
            }
        }
    }
}
