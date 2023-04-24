//
//  InitialView.swift
//  TCAExample
//
//  Created by Junhee Yoon on 2023/04/24.
//

import SwiftUI

import ComposableArchitecture

struct Initial: ReducerProtocol {
    struct State: Equatable {
        static func == (lhs: Initial.State, rhs: Initial.State) -> Bool {
            return false
        }
        
        var isNavigationActive = false
        var email = ""
        var password = ""
        var desnitationState: Destination.State?
        var alert: AlertState<Action>?
    }
    
    enum Action {
        case optionalState(Destination.Action)
        case setNavigation(isActive: Bool)
        case emailTextChanged(String)
        case passwordTextChanged(String)
        case alertDismissed
    }
    
    private enum CancelID { }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
            switch action {
            case .optionalState:
                return .none
                
            case .setNavigation(isActive: true):
                if !state.email.isEmpty && !state.password.isEmpty {
                    state.isNavigationActive = true
                    state.desnitationState = Destination.State()
                    
                } else if state.email.isEmpty {
                    state.alert = AlertState {
                        TextState("알림")
                    } actions: {
                        ButtonState(role: .none) {
                            TextState("확인")
                        }
                    } message: {
                        TextState("이메일을 입력해주세요")
                    }
                    
                } else if state.password.isEmpty {
                    state.alert = AlertState {
                        TextState("알림")
                    } actions: {
                        ButtonState(role: .cancel) {
                            TextState("확인")
                        }
                    } message: {
                        TextState("비밀번호를 입력해주세요")
                    }
                }
                return .none
                
            case .setNavigation(isActive: false):
                state.isNavigationActive = false
                state.desnitationState = nil
                return .cancel(id: CancelID.self)
                
            case let .emailTextChanged(text):
                state.email = text
                return .none
                
            case let .passwordTextChanged(text):
                state.password = text
                return .none
                
            case .alertDismissed:
                state.alert = nil
                return .none
            }
        }
}

struct InitialView: View {
    let store: StoreOf<Initial>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                VStack {
                    TextField("email", text: viewStore.binding(get: \.email, send: Initial.Action.emailTextChanged))
                    TextField("password", text: viewStore.binding(get: \.password, send: Initial.Action.passwordTextChanged))
                    NavigationLink(
                      destination: IfLetStore(
                        self.store.scope(
                          state: \.desnitationState,
                          action: Initial.Action.optionalState
                        )
                      ) { _ in
                        DestinationView()
                      },
                      isActive: viewStore.binding(
                        get: \.isNavigationActive,
                        send: Initial.Action.setNavigation(isActive:)
                      )
                    ) {
                        Text("To Next View")
                    }
                }
            }
            .navigationViewStyle(.stack)
            .alert(store.scope(state: \.alert), dismiss: .alertDismissed)
        }
    }
}

struct InitialView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            InitialView(store: Store(initialState: Initial.State(),
                                     reducer: Initial()))
        }
        .navigationViewStyle(.stack)
    }
}
