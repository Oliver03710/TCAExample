//
//  DestinationView.swift
//  TCAExample
//
//  Created by Junhee Yoon on 2023/04/24.
//

import SwiftUI

import ComposableArchitecture

struct Destination: ReducerProtocol {
    struct State: Equatable {
        
    }
    
    enum Action {
        case setNavigation
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        .none
    }
}

struct DestinationView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct DestinationView_Previews: PreviewProvider {
    static var previews: some View {
        DestinationView()
    }
}
