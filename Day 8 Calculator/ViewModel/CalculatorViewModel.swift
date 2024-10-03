//
//  CalculatorViewModel.swift
//  Day 8 Calculator
//
//  Created by Stephen Liddle on 9/26/24.
//

import Foundation

@Observable class CalculatorViewModel {

    // MARK: - Properties

    var preferences = Preferences()

    private var calculatorModel = CalculatorBrain()
    private var soundPlayer = SoundPlayer()

    // MARK: - Model access

    // MARK: - User intents

    func handleButtonTap(for buttonSpec: ButtonSpec) {
        if preferences.soundIsEnabled {
            soundPlayer.playSound(named: "Click2.m4a")
        }
    }

    // MARK: - Helpers

}
