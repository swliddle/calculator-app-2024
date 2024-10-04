//
//  Day_8_CalculatorApp.swift
//  Day 8 Calculator
//
//  Created by Stephen Liddle on 9/24/24.
//

import SwiftUI

@main
struct Day_8_CalculatorApp: App {
    var body: some Scene {
        WindowGroup {
            CalculatorView(calculator: CalculatorEngine())
        }
    }
}
