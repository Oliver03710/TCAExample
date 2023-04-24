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
        var isNavigationActive = false
        var email = ""
        var password = ""
        var desnitationState: Destination.State?
    }
    
    enum Action {
        case optionalState(Destination.Action)
        case setNavigation(isActive: Bool)
        case emailTextChanged(String)
        case passwordTextChanged(String)
    }
    
    private enum CancelID { }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .optionalState:
                return .none
                
            case .setNavigation(isActive: true):
                if !state.email.isEmpty && !state.password.isEmpty {
                    state.isNavigationActive = true
                }
                state.desnitationState = Destination.State()
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
            }
        }
        .ifLet(\.desnitationState, action: /Action.optionalState) {
            Destination()
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
