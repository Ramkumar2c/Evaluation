//
//  TaxFactory.swift
//  Demo
//
//  Created by Ramkumar Chandrasekaran on 7/18/19.
//  Copyright © 2019 Ramkumar Chandrasekaran. All rights reserved.
//

import Foundation

class TaxFactory {

    private static var states = [State]()
    
    static func getStates() -> [State] {
        states = [stateCA(), stateWA(), stateOR(), stateNV(), stateID(), stateUT(), stateAZ(), stateWY(), stateCO(), stateND()]
        return states
    }
    
    private static func stateCA() -> State {
        return State(name:"CA", tax:8.5)
    }
    
    private static func stateWA() -> State {
        return State(name:"WA", tax:6.5)
    }

    private static func stateOR() -> State {
        return State(name:"OR", tax:0.0)
    }
    
    private static func stateNV() -> State {
        return State(name:"NV", tax:6.85)
    }
    
    private static func stateID() -> State {
        return State(name:"ID", tax:6)
    }
    
    private static func stateUT() -> State {
        return State(name:"UT", tax:5.95)
    }
    
    private static func stateAZ() -> State {
        return State(name:"AZ", tax:6.6)
    }
    
    private static func stateWY() -> State {
        return State(name:"WY", tax:4)
    }

    private static func stateCO() -> State {
        return State(name:"CO", tax:2.9)
    }
    
    private static func stateND() -> State {
        return State(name:"ND", tax:5)
    }

    static func getStateByName(name: String) -> State? {
       return states.filter { (state) -> Bool in
            return state.name == name
        }.first
    }
}
